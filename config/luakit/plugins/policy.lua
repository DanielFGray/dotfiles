-------------------------------------------------------------------------------
-- Advanced URI-based content filter v0.1.1a                                 --
--  Combines functionality of AdBlock via pattern-match based blocking,      --
--  domain/sub-domain matching white and black listing,                      --
--  a RequestPolicy-like rule system to default-deny 3rd-party requests      --
--                                                                           --
-- Disclaimer: while this is intended to increase browser security and       --
-- help protect privacy, there is no guarantee.  Rely on it at your own risk! --
-------------------------------------------------------------------------------

local info = info
local pairs = pairs
local ipairs = ipairs
local assert = assert
local unpack = unpack
local type = type
local io = io
local os = os
local string = string
local table = table
local tostring = tostring
local tonumber = tonumber
local webview = webview
local window = window
local lousy = require("lousy")
local theme = theme
local widget = widget
local util = lousy.util
local soup = soup
local chrome = require("chrome")
local capi = { luakit = luakit , sqlite3 = sqlite3 }
local sql_escape = lousy.util.sql_escape
local add_binds, add_cmds = add_binds, add_cmds
local new_mode, menu_binds = new_mode, menu_binds
local lfs = require("lfs")
local setmetatable = setmetatable

-- Public Suffix Lib
local tld = require("tld")
local getdomain = tld.getdomain

-- Calls modifed adblock
local adblock = require("plugins.adblock")

module("plugins.policy")

pdebug = function (...) io.stdout:write(string.format(...) .. "\n") end

-- Settings Flags =============================================================
filtering = {
	-- Flag to accept all requests (disabled all blocking)
	acceptall = false,
	-- Flag to enable/disable AdBlock / Pattern-Based Blocking
	adblock = true,
	-- Flag to enable/disable additional scrutiny of 3rd-party requests
	requestpolicy = true,
	-- Flag for whether a subdomain is treated as a 3rd party relative to other subdomains or master domain
	strictsubdomain = false,
	-- Flas for whether to show status bar widget
	widget = true
}

local policy_dir = capi.luakit.data_dir

-- Below is the actual internals of the plugin, here be dragons ---------------
-------------------------------------------------------------------------------

-- Cache to reduce sql calls
local cache = {}
setmetatable(cache, { __mode = "k" })

-- A table to store data for navigation and resource requests
-- it has per-view instances, indexed via navto[v].fields
local navto = {}
setmetatable(navto, { __mode = "k" })

-- Exception listing
local exlist = { white = {}, third = {white = {} } }

-- Makes the following more clear... eg: return codes and internal constants
-- allowing is zero so that reasons for denial can be communicated
local ALLOW = 0
local DENIED = { BLACKLIST = 1, ADBLOCK = 2, NO_WHITELIST = 3, BLACKLISTED_TP = 4} 
local ANY_PARTY, THIRD_PARTY = 1, 2
local reasonstring = {"Blacklisted", "ABP", "CDR", "Blacklisted-CDR", "Other"}

-- sqlite command stings
local create_tables = [[
PRAGMA synchronous = OFF;
PRAGMA secure_delete = 1;
CREATE TABLE IF NOT EXISTS whitelist (
	id INTEGER PRIMARY KEY,
	domain TEXT UNIQUE);
CREATE TABLE IF NOT EXISTS blacklist (
	id INTEGER PRIMARY KEY,
	domain TEXT UNIQUE);
CREATE TABLE IF NOT EXISTS tp_whitelist (
	id INTEGER PRIMARY KEY,
	domain TEXT,
	rdomain TEXT);
CREATE TABLE IF NOT EXISTS tp_blacklist (
	id INTEGER PRIMARY KEY,
	domain TEXT,
	rdomain TEXT);
]]

local sql_format = {
	match_list             = "SELECT * FROM %slist WHERE domain == %s;",
	add_list               = "INSERT INTO %slist VALUES (NULL, %s);",
	remove_list            = "DELETE FROM %slist WHERE domain == %s;",
	match_tp_list          = "SELECT * FROM tp_%slist WHERE domain == %s and rdomain == %s;",
	add_tp_list            = "INSERT INTO tp_%slist VALUES (NULL, %s, %s);",
	remove_tp_list_exact   = "DELETE FROM tp_%slist WHERE domain == %s and rdomain == %s;",

	remove_tp_list_domain  = "DELETE FROM tp_%slist WHERE domain == %s;",
	remove_tp_list_rdomain = "DELETE FROM tp_%slist WHERE rdomain == %s;",
}

-- Open or create & initiaze dbi
initalize_rpdb = function()
	if rpdb then return end
	rpdb = capi.sqlite3{ filename = policy_dir .. "/policy.db" }
	rpdb:exec(create_tables)
end

-- Helper functions that perform various utility functions ========================

-- Check if query is domain or a subdomain of host
local subdomainmatch = function(host, query)
	if host == query then
		return true
	else
		local abits = util.string.split(string.reverse(host or ""), "%.")
		local bbits = util.string.split(string.reverse(query or ""), "%.")
		-- If host is an IP abort, eg: 10.8.4.1 is not a subdomain of 8.4.1
		if host and string.match(host, "^%d%.%d%.%d%.%d$") then return false end
		-- TODO ipv6 match
		for i,s in ipairs(abits) do
			if s ~= bbits[i] then
				return false
			end
		end
		return true
	end
end

-- Checks domains for a match
local domainmatch = function (a, b)
	-- If main uri (a) is nil, then it is always "first party"
	-- If a == b then they are the same domain
	-- Otherwise do a match score and make a fuzzy match
	if not a or a == b then
		return true
	elseif not filtering.strictsubdomain then
		local abits = util.string.split(string.reverse(a) or "", "%.")
		local bbits = util.string.split(string.reverse(b) or "", "%.")
		local matching = 0
		-- If an IP, don't do partial matches, TODO ipv6 match
		if string.match(a, "^%d%.%d%.%d%.%d$") then return false end
		-- Count matching bits
		for i,s in ipairs(abits) do
			if s == bbits[i] then
				matching = matching + 1
			else
				break
			end
		end
		-- Check the effective tlds of a and b and use that + 1 as the minimum matching requirement
		local ab = util.string.split(getdomain(a) or "", "%.")
		local bb = util.string.split(getdomain(b) or "", "%.")
		local needed_match = ( (#ab > #bb) and #ab) or #bb
		if matching >= needed_match then
			return true
		end
	end
	return false
end

-- Returns whether or not rhost is whitelisted
local islisted = function (host, rhost, typ, party)
	if party == THIRD_PARTY then
		local host_bits = util.table.reverse(util.string.split(host or "", "%.") or {})
		-- Get base domain, we do not want to match vs. just public suffixes
		local n = 1
		local phost = getdomain(host)
		if not string.match(phost, "^[0-9%.]$") then
			local pbits = util.string.split(phost, "%.")
			n = #pbits + 1
		else
			n = #host_bits
		end
		local list, tlist
		-- Make list to match rhost against, use cache if valid
		if cache[host] and cache[host][typ] then
			list = cache[host][typ]
			if typ == "white" then
				tlist = exlist.third.white["all"]
				repeat
					tlist = util.table.join(tlist, exlist.third.white[phost] or {})
					phost = (host_bits[n] or "").. "." .. phost
					n = n + 1
				until n > #host_bits + 1
			end
		else
			list = rpdb:exec(string.format("SELECT * FROM tp_%slist WHERE domain = %s;", typ, sql_escape("all")))
			tlist = exlist.third.white["all"]
			repeat
				local rows = rpdb:exec(string.format("SELECT * FROM tp_%slist WHERE domain = %s;", typ, sql_escape(phost)))
				list = util.table.join(list, rows or {})
				if typ == "white" then
					tlist = util.table.join(tlist, exlist.third.white[phost] or {})
				end
				phost = (host_bits[n] or "").. "." .. phost
				n = n + 1
			until n > #host_bits + 1
			-- Save list in cache
			if not cache[host] then cache[host] = {} end
			cache[host][typ] = list
		end
		-- Match vs lists
		for _,v in pairs(list) do
			if subdomainmatch(v.rdomain, rhost) or v.rdomain == "all" then
				return true
			end
		end
		-- Only check exceptions if checking a whitelist
		if typ == "white" then
			for k,v in pairs(tlist) do
				if subdomainmatch(v, rhost) or v == "all" then
					return true
				end
			end
		end
		return false
	else
		local list
		if cache[typ] then
			list = cache[typ]
		else
			list = rpdb:exec(string.format("SELECT * FROM %slist;", typ))
			cache[typ] = list
		end

		for _,v in pairs(list) do
			if subdomainmatch(v.domain, rhost) then
				return true;
			end
		end
		-- Only check exceptions if checking a whitelist
		if typ == "white" then
			for k,v in pairs(exlist.white) do
				if subdomainmatch(k, rhost) then
					return true;
				end
			end
		end
	end
	-- No match was found
	return false
end

-- Check Pattern list for matches to rules (aka AdBlocking)
local pattern_match = function (req)
	-- This checks that the AdBlock Module is loaded, and if so it calls the matching function
	-- I originally intended to re-implement this as part of this plugin, but I decided that
	-- it was better to just use a minimally modified version of the upstream AdBlock plugin
	if filtering.adblock and adblock and adblock.match then
		return not adblock.match(req, "none")
	end
	return false
end

-- Main logic checking if a request should be allowed or denied
local checkpolicy = function (host, requested, nav, firstnav)
	-- A request for a nil uri is denied (should never happen)
	if not requested then
		return DENIED.BLACKLIST
	end
	-- Should always accept these
	if string.match(requested, "about:blank") or filtering.acceptall then
		return ACCEPT
	end
	-- Get host from requested uri
	local rpuri = lousy.uri.parse(requested)
	local req = { host = string.lower(rpuri and rpuri.host or "") }
	-- webview.uri is nil for the first requests when loading a page (they are always first party)	
	local puri = lousy.uri.parse(host or "")
	host = puri and puri.host or req.host

	local wlisted = false
	-- Skip checks for data: uris - they would be covered by the policies of whatever they were embedded in
	if not string.match(requested, "^data:") then
		-- Blacklisting overrides whitelist
		if islisted(nil, req.host, "black", ANY_PARTY) then
			return DENIED.BLACKLIST
		end
	
		-- Check if requested domain is whitelisted
		wlisted = islisted(nil, req.host, "white", ANY_PARTY)

		-- Whitelisting overrides AdBlocking/Pattern Block
		if not wlisted and filtering.adblock then
			-- If AdBlock / Pattern matching is enabled, check if requested uri matches and should be blocked
			if pattern_match(requested) then
				return DENIED.ADBLOCK
			end
		end
	end

	-- If RequestPolicy is disabled or this is a first party request accept
	-- If this is a a navigation request or the first request post-navigation, relax CDR, we likely clicked on a link
	-- data: uri's are not cross-domain, however we might want to check those with file filtering
	if nav or firstnav or not filtering.requestpolicy or domainmatch(host, req.host) or string.match(requested, "^data:")then
		return ACCEPT
	else
		-- Check if this domain is blacklised for ALL 3rd-party requests -OR-
		-- blacklisted for 3rd party requests for the main domain
		if islisted(host, req.host, "black", THIRD_PARTY) then
			return DENIED.BLACKLISTED_TP
		end

		-- If requested host is whitelisted universally or for this host for this third party, set to accept
		local wlistedtp = islisted(host, req.host, "white", THIRD_PARTY)
		if not wlistedtp then
			return DENIED.NO_WHITELIST
		end

		return ACCEPT
	end
end

-- Make a table of request's hosts and keep a count of accepted and denied requests
local concat_res = function (l, uri, r)
	if uri then
		local puri = lousy.uri.parse(uri)
		if puri and puri.host then
			-- If the host doesn't have a table yet, add it
			if not l[puri.host] then
				l[puri.host] = {accept = 0, deny = 0, reasons = {}}
			end
			-- Increment counter (s)
			if not r then
				l[puri.host].accept = 1 + l[puri.host].accept
			else
				l[puri.host].deny = 1 + l[puri.host].deny
				-- TODO get make this not so hacky ??
				l[puri.host].reasons[reasonstring[r]] = (l[puri.host].reasons[reasonstring[r]] or 0) + 1
			end
		end
	end
end

-- Connect signals to all webview widgets on creation
-- TODO check robustness of the firstnav system
webview.init_funcs.policu_signals = function (view, w)
    view:add_signal("navigation-request", 
					function (v, uri)
						-- Check if request should be accepted or denied
						local r = checkpolicy(v.uri, uri, true , false)

						-- if navto[v] does not exist set to empty table
						navto[v] = navto[v] or {}

						-- Only do the following if request was accepted (r = 0)
						if not r then
							-- Set temp navigation uri to the requested uri
							navto[v].uri = uri
							-- Make an empty request table if one does not exist	
							navto[v].res = navto[v].res or {}
							-- Add request to the resource request table
							--concat_res(navto[v].res, uri, r) -- TODO I don't think this is needed?
							-- XXX  "bug-fix" ensures uri bar gets updated on clicking intra-page links
							w:update_uri()
--						elseif r == DENIED.BLACKLIST then
--							w:error("Policy: Blacklisted domain '" .. uri .. "'")
						end
						-- Hack to get luakit:// pages to load
						local puri = lousy.uri.parse(uri or "")
						if puri and puri.scheme == "luakit" then
						else
							return not r
						end				
					end)
 
    view:add_signal("resource-request-starting",
					function (v, uri)
						-- Check if request should be accepted or denied
						local r = checkpolicy(navto[v].uri or v.uri, uri, false, (navto[v] or {}).first)

						-- if w.navto[v] does not exist set to empty table
						navto[v] = navto[v] or {}
						-- Clear temp navigation uri
						navto[v].uri = nil
						-- Clear first flag
						navto[v].first = false
						-- Add the request to the request table
						concat_res(navto[v].res, uri, r)

						-- Hack to get luakit;// pages to load
						local puri = lousy.uri.parse(uri or "")
						if puri and puri.scheme == "luakit" then
						else
							return not r
						end
					end)

    view:add_signal("load-status",
					function (v, status)
						--pdebug(("policy: load-status signal uri = " .. (v.uri or "") .. "status = " .. status) or "policy: load-status ???")
						navto[v] = navto[v] or {}
						if status == "provisional" then
							-- Resets Resource requests
							navto[v].res = {}
							navto[v].first = true
						elseif status == "committed" then
							navto[v].first = false
						end
        			end)
end

-- TODO - All the chrome stuff...
-- luakit://policy/help			help page, lists commands and explains how to use plugin
-- luakit://policy				displys settings status and links to other pages
-- luakit://policy/whitelist	list of whitelisted domains (button to remove, search, and add new entries)
-- luakit://policy/blacklist	list of blacklisted domains (button to remove, search, and add new entries)
-- luakit://policy/cdr/whitelist  list of CDR whitelist entries (")
-- luakit://policy/cdr/blacklist  list of CDR blacklist entries (")
-- luakit://policy/adblock		  redirects to luakit://adblock 

load = function ()
	-- Load the db with the white/black lists
	initalize_rpdb()
end

-- Functions called by user commands ========================================== 
local togglestrings = {
	acceptall = "unconditional accepting of all requests.",
	adblock = "pattern-based blocking (aka AdBlock).",
	requestpolicy = "cross-domain request policy blocking.",
	strictsubdomain = "strict matching for subdomains.",
	widget = "visibility of status widget.",
}

local rp_setting = function (field, value, w)
	-- Check that field is a valid settings field
	if togglestrings[field] then
		-- Check is toggling or setting value
		if value == "toggle" then
			filtering[field] = not filtering[field]
		else
			filtering[field] = value
		end
		-- User feedback on what setting was changed and what it was changed to
		w:update_policy(true)
		w:notify("Policy: " .. (value and "en" or "dis") .. "abled " .. togglestrings[field])
	end
	-- return validity of the setting
	return togglestrings[field] and true
end

-- Clears Excption lists and returns the number of items they contained
local clear_exlist = function ()
	local listlen = #exlist.white
	for _,v in pairs(exlist.third.white) do
		for _,_ in pairs(v) do
			listlen = listlen + 1
		end
	end
	exlist.white = {}
	exlist.third.white = {}
	return listlen or 0
end

-- Returns true if entery exists
local checkList = function (typ, hosts)
	local host = hosts[1]
	local rhost = hosts[2]
	if rhost then
		if typ == "ex" then
			return exlist.third.white[host] and util.table.hasitem(exlist.third.white[host], rhost) and true	
		elseif typ == "white" or typ == "black" then
			local row = rpdb:exec(string.format(sql_format.match_tp_list, typ, sql_escape(host), sql_escape(rhost)))
			return row and row[1] and true	
		end
	else
		if typ == "ex" then
			return util.table.hasitem(exlist.white, host) and true
		elseif typ == "white" or typ == "black" then
			local row = rpdb:exec(string.format(sql_format.match_list, typ, sql_escape(host)))
			return row and row[1] and true
		end
	end
end


-- Return Strings, makes localization easier
local retStr = {
	sucess = {
		add = {
			one = {
				ex = "Exception added for %s",
				white = "Added %s to whitelist",
				black = "Added %s to blacklist"},
			mul = {
				ex = "Exception added for requests from %s to %s",
				white = "Whitelisted requests from %s made to %s",
				black = "Blacklisted requests from %s made to %s"},
		},
		del = {
			one = {
				ex = "Removed exception for %s",
				white = "Removed %s from whitelist",
				black = "Removed %s from blacklist"},
			mul = {
				ex = "Exception removed for requests from %s to %s",
				white = "Removed whitelisting of requests from %s to %s",
				black = "Removed blacklisting of requests from %s to %s"},
		},
	},
	failure = {
		add = {
			one = {
				ex = "Exception had already been granted to %s!",
				white = "%s was already whitelisted!",
				black = "%s was already blacklisted!"},
			mul = {
				ex = "Exception had already been granted to requests from %s to %s!",
				white = "Requests from %s to %s were already whitelisted!",
				black = "Requests from %s to %s were already blacklisted!"},
		},
		del = {
			one = {
				ex = "Exception had not been granted to %s!",
				white = "%s was not whitelisted!",
				black = "%s was not blacklsited!"},
			mul = {
				ex = "Requests from %s to %s had not been granted an exception!",
				white = "Requests from %s to %s were not whitelisted!",
				black = "Requests from %s to %s were not blacklisted!"},
		},
}} -- end retStr

local modList = function (cmd, typ, hosts, w)
	local host = hosts[1]
	local rhost = hosts[2]
	local listed = checkList(typ, hosts)
	local num = (rhost and "mul") or "one"
	local suc = "failure"
	if cmd == "add" then
		if not listed then
			if rhost then
				if typ == "white" or typ == "black" then
					rpdb:exec(string.format(sql_format.add_tp_list, 
					                        typ, sql_escape(host), sql_escape(rhost)))
				else
					if not exlist.third.white[host] then
						exlist.third.white[host] = {}
					end
					table.insert(exlist.third.white[host], rhost)
				end
			else
				if typ == "white"  or typ == "black" then
					rpdb:exec(string.format(sql_format.add_list, typ, sql_escape(host)))
				else
					table.insert(exlist.white, host)
				end
			end
			suc = "sucess"
		end
	elseif cmd == "del" then
		if listed then
			if rhost then
				if typ == "white" or typ == "black" then
					rpdb:exec(string.format(sql_format.remove_tp_list_exact,
					                        typ, sql_escape(host), sql_escape(rhost)))
				else
					local i = util.table.hasitem(exlist.third.white[host] or {}, rhost)
					if i then table.remove(exlist.third.white[host], i) end
				end
			else
				if typ == "white" or typ == "black" then
					rpdb:exec(string.format(sql_format.remove_list, typ, sql_escape(host)))
				else
					local i = util.table.hasitem(exlist.white, host)
					if i then table.remove(exlist.white, i) end
				end
			end
			suc = "sucess"
		end
	end
	-- Feedback on sucess/failure
	if suc == "sucess" then
		-- Changed [typ]-list, clear cache
		cache = {}
		w:notify(string.format(retStr[suc][cmd][num][typ], host or "", rhost or ""))
	else
		w:error(string.format(retStr[suc][cmd][num][typ], host or "", rhost or ""))
	end
end

-- Master user commands parser
local rp_command = function(command, w, a)
	a = string.lower(a or "")
	local args = util.string.split(util.string.strip(a or ""), " ")

	if command == "set" then
		-- Set request policy behaviors
		local val = not string.match(args[1], "!$")
		local set = string.match(args[1], "(.*)!$") or args[1]
		if not rp_setting(set, val, w) then
			w:error("Policy: set '" .. args[1] .. "' is not a valid setting. (adblock[!], requestpolicy[!], acceptall[!], strictsubdomain[!])")
		end
	elseif command == "clear" then
		w:notify(string.format("Removed %d policy exceptions.", clear_exlist()))
	else
		-- else it's wl/bl/ex and args will be hosts and require special parsing
		if #args == 0 or #args > 2 then
			w:error("Policy: Wrong number of arguments!")
			return
		end
		-- Attempt to get a host/rhost out of args
		local host  = args[1] and ((args[1] == "all" and "all") or (lousy.uri.parse(args[1]) or {}).host)
		local rhost = args[2] and ((args[2] == "all" and "all") or (lousy.uri.parse(args[2]) or {}).host)

		-- Convert empty rhost to nil
		if rhost == "" then rhost = nil end
		--TODO add host/rhost cheking vs public suffixes with getdomain()
		if #args == 1 then
			if not host then
				w:error("Bad argument error. (" .. host .. ")")
				return
			end
		else
			if not host or not rhost then
				w:error("Bad argument error. (" .. host .. ", " .. rhost ..")")
				return
			end
		end

		if command == "wl" or command == "whitelist" then
			modList("add", "white", {host, rhost}, w)
		elseif command == "bl" or comamnd == "blacklist" then
			modList("add", "black", {host, rhost}, w)
		elseif command == "ex" or command == "exception" then
			modList("add", "ex", {host, rhost}, w)
		elseif command == "wl!" or command == "whitelist!" then
			modList("del", "white", {host, rhost}, w)
		elseif command == "bl!" or command == "blacklist!" then
			modList("del", "black", {host, rhost}, w)
		elseif command == "ex!" or command == "exception!" then
			modList("del", "ex", {host, rhost}, w)
		else
			w:error("Policy: '" .. command .. "' is not a valid request policy command!")
		end
	end
end

-- Add commands ===============================================================
new_mode("policymenu", {
    enter = function (w)
        local afg = theme.rpolicy_active_menu_fg or theme.proxy_active_menu_fg
        local ifg = theme.rpolicy_inactive_menu_fg or theme.proxy_inactive_menu_fg
        local abg = theme.rpolicy_active_menu_bg or theme.proxy_active_menu_bg
        local ibg = theme.rpolicy_inactive_menu_bg or theme.proxy_inactive_menu_bg

		local template = ' Allowed: <span foreground = "#0f0">%2d</span>  Blocked: <span foreground = "#f00">%2d</span> %s'
		local reason = { start = "[Reason(s):", ends  = "]"}

		local main = (lousy.uri.parse(w.view.uri) or {}).host or "about:config"
        local rows = {}
		local main_row
        for host,pol in pairs(navto[w.view].res) do
			-- Generate a list of reason why requests were blocked
			local reasons = ""
			for k,_ in pairs(pol.reasons) do
				reasons = reasons .. (k and " ") .. k
			end
			local notcdr = domainmatch(main, host)
			-- Underline the main domain of the host
			local domain = string.gsub(getdomain(host), "[%.%-]", "%%%1")
			local formhost = string.gsub(host, domain, "<u>" .. domain .. "</u>")
			if host == main then
				main_row = {
				" " .. formhost .. "", string.format(template, pol.accept ,pol.deny, ((reasons ~= "") and reason.start .. reasons .. reason.ends) or ""),
                host = host, pol = pol,
                fg = (notcdr and afg) or ifg,
                bg = ibg}
			else
	            table.insert(rows, (notcdr and 1) or #rows +1,
				{   " " .. formhost .. "", string.format(template, pol.accept ,pol.deny, ((reasons ~= "") and reason.start .. reasons .. reason.ends) or ""),
        	        host = host, pol = pol,
            	    fg = (notcdr and afg) or ifg,
                	bg = ibg,
	            })
			end
        end
		-- Add main host to top of the list
		if main_row then
			table.insert(rows, 1, main_row)
		end
		-- Add title row entry
		table.insert(rows, 1, { "Domains requested by " .. main, "Actions Taken", title = true })
        w.menu:build(rows)
        w:notify("Use j/k to move, Enter to select a host and open actions submenu, or h to open policy help (and full list of actions).", false)
    end,

    leave = function (w)
        w.menu:hide()
    end,
})

local genLine = function ( fmt, cFmt, cm, h, rh, ifg, ibg)
	return {string.format(fmt, h, rh),
			string.format(cFmt, cm, h, rh), 
	        host = h, rhost = rh, cmd = cm,
			fg = ifg, bg = ibg}
end

new_mode("policysubmenu", {
    enter = function (w)
        local ifg = theme.rpolicy_inactive_menu_fg or theme.inactive_menu_fg
        local ibg = theme.rpolicy_inactive_menu_bg or theme.inactive_menu_bg
		local host = navto[w.view].selectedhost or "REQ_HOST"
		local main = (lousy.uri.parse(w.view.uri or "") or {}).host or "HOST"
        local rows = {{ "Actions for " .. host , "Command", title = true }}
	-- Any host
		if checkList("white", {host, nil}) then
			table.insert(rows, genLine("Remove %s from whitelist", " :rp %s %s", "wl!", host, nil, ifg, ibg))
		else
			table.insert(rows, genLine("Add %s to whitelist", " :rp %s %s", "wl", host, nil, ifg, ibg))
		end

		if checkList("black", {host, nil}) then
			table.insert(rows, genLine("Remove %s from blacklist", " :rp %s %s", "bl!", host, nil, ifg, ibg))
		else
			table.insert(rows, genLine("Add %s to blacklist", " :rp %s %s", "bl", host, nil, ifg, ibg))
		end

		if checkList("ex", {host, nil}) then
			table.insert(rows, genLine("Revoke exception for %s", " :rp %s %s", "ex!", host, nil, ifg, ibg))
		else
			table.insert(rows, genLine("Grant an exception for %s", " :rp %s %s", "ex", host, nil, ifg, ibg))
		end

	-- For main host
		if host == main then
			if checkList("white", {host, "all"}) then
				table.insert(rows, genLine("Revoke complete CDR whitelisting from %s", " :rp %s %s %s", "wl!", host, "ALL", ifg, ibg))
			else
				table.insert(rows, genLine("Allow all CDRs from %s", " :rp %s %s %s", "wl", host, "ALL", ifg, ibg))
			end

			if checkList("black", {host, "all"}) then
				table.insert(rows, genLine("Revoke complete CDR blacklisting from %s", " :rp %s %s %s", "bl!", host, "ALL", ifg, ibg))
			else
				table.insert(rows, genLine("Deny all CDRs from %s", " :rp %s %s %s", "bl", host, "ALL", ifg, ibg))
			end

			if checkList("ex", {host, "all"}) then
				table.insert(rows, genLine("Revoke complete CDR exception from %s", " :rp %s %s %s", "ex!", host, "ALL", ifg, ibg))
			else
				table.insert(rows, genLine("Grant an excpetion for all CDRs from %s", " :rp %s %s %s", "ex", host, "ALL", ifg, ibg))
			end

	-- For other hosts
		else
			if checkList("white", {main, host}) then
				table.insert(rows, genLine("Revoke whitelisting of CDRs from %s to %s", " :rp %s %s %s", "wl!", main, host, ifg, ibg))
			else
				table.insert(rows, genLine("Allow CDRs from %s to %s", " :rp %s %s %s", "wl", main, host, ifg, ibg))
			end

			if checkList("black", {main, host}) then
				table.insert(rows, genLine("Revoke whitelisting of CDRs from %s to %s", " :rp %s %s %s", "bl!", main, host, ifg, ibg))
			else
				table.insert(rows, genLine("Deny CDRs from %s to %s", " :rp %s %s %s", "bl", main, host, ifg, ibg))
			end

			if checkList("white", {"all", host}) then
				table.insert(rows, genLine("Revoke whitelisting of CDRs from %s to %s", " :rp %s %s %s", "wl!", "ALL", host, ifg, ibg))
			else
				table.insert(rows, genLine("Allow CDRs from %s to %s", " :rp %s %s %s", "wl", "ALL", host, ifg, ibg))
			end

			if checkList("black", {"all", host}) then
				table.insert(rows, genLine("Revoke whitelisting of CDRs from %s to %s", " :rp %s %s %s", "bl!", "ALL", host, ifg, ibg))
			else
				table.insert(rows, genLine("Deny CDRs from %s to %s", " :rp %s %s %s", "bl", "ALL", host, ifg, ibg))
			end

			if checkList("ex", {main, host}) then
				table.insert(rows, genLine("Revoke exception for CDRs from %s to %s", " :rp %s %s %s", "ex!", main, host, ifg, ibg))
			else
				table.insert(rows, genLine("Grant an excpetion for CDRs from %s to %s", " :rp %s %s %s", "ex", main, host, ifg, ibg))
			end

			if checkList("ex", {"all", host}) then
				table.insert(rows, genLine("Revoke exception for CDRs from %s to %s", " :rp %s %s %s", "ex!", "ALL", host, ifg, ibg))
			else
				table.insert(rows, genLine("Grant an excpetion for CDRs from %s to %s", " :rp %s %s %s", "ex", "ALL", host, ifg, ibg))
			end
		end
	
        w.menu:build(rows)
        w:notify("Use j/k to move, Enter to execute action, S-Enter to edit command, or q to exit.", false)
    end,

    leave = function (w)
        w.menu:hide()
    end,
})

-- Adds keybindings for the policy menus
local key = lousy.bind.key
add_binds("policymenu", lousy.util.table.join({
    -- Select user agent
    key({}, "Return",
        function (w)
			local row = w.menu:get()
			if row then
				navto[w.view].selectedhost = row.host
    	        w:set_mode("policysubmenu")
			end
		end),
    -- Exit menu
    key({}, "q", function (w) w:set_mode() end),
}, menu_binds))

add_binds("policysubmenu", lousy.util.table.join({
	key({}, "Return",
        function (w)
			local row = w.menu:get()
			if row and row.cmd then
				w:set_mode()
				rp_command(row.cmd, w, (row.host or "") .. " " .. (row.rhost or ""))
            end
        end),
	key({"Shift"}, "Return",
        function (w)
			local row = w.menu:get()
            if row and row[2] then
                w:enter_cmd(util.string.strip(row[2]))
            end
        end),
    -- Exit menu
    key({}, "q", function (w) w:set_mode() end),
}, menu_binds))

-- Add ex-mode commands
local cmd = lousy.bind.cmd
add_cmds({
    cmd({"requestpolicy", "rp"}, "view current page requests",
        function (w, a)
            if not a then
                w:set_mode("policymenu")
			else
				-- if called with an argument, try to interprate the command
				local args = util.string.split(util.string.strip(a or ""), " ")
				local aa = string.match(a, ".- (.*)")
				rp_command(args[1], w, aa)
			end
        end),
	cmd({"rp-whitelist", "rp-wl"}, "add a whitelist entry",
		function(w, a, o)
			rp_command((o.bang and "wl!") or "wl", w, a)
		end),
	cmd({"rp-blacklist", "rp-bl"}, "add a blacklist entry",
		function(w, a, o)
			rp_command((o.bang and "bl!") or "bl", w, a)
		end),
	cmd({"rp-exception", "rp-ex"}, "grant temporary exceptions to request polices",
		function(w, a, o)
			rp_command((o.bang and "ex!") or "ex", w, a)
		end),
	cmd({"rp-set"}, "set request policy plugin behaviors",
		function(w, a)
			rp_command("set", w, a)
		end),	
	cmd({"rp-clear"}, "clear request policy exceptions",
		function(w, a)
			rp_command("clear", w, a)
		end),
})

-- Adds buffer command to invoke the policy menu and temp-allow all
-- ,pp = open policy menu
-- ,pa = allow all CDR from current host for this session
-- ,pt = toggle CDR filtering
local buf = lousy.bind.buf
add_binds("normal", {
	buf("^,pp$", function (w) w:set_mode("policymenu") end),
	buf("^,pa$", function(w) 
					if w.view and w.view.uri ~= "about:blank" then
						rp_command("ex", w, w.view.uri .. " all")
					end end),
	buf("^,pt$", function (w) rp_setting("requestpolicy", "toggle" ,w) end),
})

-- Status Bar Widget ==========================================================
-- Create the indictor widget on window creation
window.init_funcs.build_policy_indicator = function(w)
	local i = w.sbar.r
	i.policy = widget{type="label"}
	i.layout:pack(w.sbar.r.policy)
	i.layout:reorder(w.sbar.r.policy, 1)
	i.policy.fg = theme.buf_sbar_fg
	i.policy.font = theme.buf_sbar_font
	w:update_policy()
	-- Update indicator on tab change
	w.tabs:add_signal("switch-page", function (_,view)
		capi.luakit.idle_add(function() w:update_policy(w) return false end)
	end)
end

-- Update indicator on page navigation
webview.init_funcs.policy_update = function(view, w)
	view:add_signal("load-status", function (v, status)
		if w.view == view then
			if status == "committed" or status == "provisional" then
				w:update_policy(false)
			elseif status == "failed" or status == "finished" then
				w:update_policy(true)
			end
		end
	end)
end

-- Update contents of request policy widget
window.methods.update_policy = function(w, fin)
	if not w.view then return end
	local pw = w.sbar.r.policy
	if filtering.widget then
		local text
		if not fin then
			text = "[Loading...]"
		else
			text = "["
			if filtering.acceptall then
				text = text .. "AcceptAll"
			else
				if navto[w.view].res then
					local acc, rej = 0, 0
					for _,pol in pairs(navto[w.view].res) do
						acc = acc + pol.accept
						rej = rej + pol.deny
					end
					text = text .. string.format("<span foreground=\"#0f0\">A%d</span> <span foreground=\"#f00\">B%d</span>", acc, rej)
				end
			end
			text = text .. "]"
		end
		pw.text = text
		pw:show()
	else
		pw:hide()
	end
end
-- Call load()
load()
