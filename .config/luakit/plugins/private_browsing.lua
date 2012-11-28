-------------------------------------------------------------------------------
--                                                                           --
-- Blocks Adding "Private Browsing" Hosts to History DB                      --
--                                                                           --
-------------------------------------------------------------------------------

local string = string
local window = window
local webview = webview
local widget = widget
local theme = theme
local luakit = luakit
local domain_props = domain_props
local lousy = require("lousy")
local util = lousy.util
local soup = soup
local history = require("history")
local nohist = globals.history_blacklist or {}

local print = print
module("plugins.private_browsing")

local indicator = { private = "!hist", notprivate = "" }

-- Load themes, if undefined fallback
theme.pbm_font = theme.pbm_font or theme.buf_sbar_font
theme.pbm_fg   = theme.pbm_fg   or theme.buf_sbar_fg
theme.pbm_bg   = theme.pbm_bg   or theme.buf_sbar_bg

-- Create the indictor widget on window creation
window.init_funcs.build_pindicator = function(w)
	local i = w.sbar.r
	i.prvt = widget{type="label"}
	i.layout:pack(w.sbar.r.prvt)
	i.layout:reorder(w.sbar.r.prvt, 2)	
	i.prvt.font = theme.buf_sbar_font
	i.prvt.fg = theme.buf_sbar_fg
	w:update_prvt()
	-- Update indicator on tab change
	w.tabs:add_signal("switch-page", function (_,view)
		luakit.idle_add(function() w:update_prvt(w) return false end)
	end)
end

-- Update indicator on page navigation
webview.init_funcs.prvt_update = function(view, w)
	view:add_signal("load-status", function (v, status)
		if status == "comitted" or status == "failed" or status == "finished" then
			w:update_prvt()
		end
	end)
end

-- Updates widget based on status
window.methods.update_prvt = function(w)
	if not w.view then return end
    local private_br = w.view.enable_private_browsing

	local domain = (soup.parse_uri(w.view.uri or "") or {}).host or ""
    domain = string.match(domain, "^www%.(.+)") or domain
	repeat
		private_br = private_br or util.table.hasitem(nohist, domain)
		domain = string.match(domain, "%.(.+)")
	until not domain

    local prvt = w.sbar.r.prvt
	-- Set widget text based on privacy setting  
	prvt.text = (private_br and indicator.private) or indicator.notprivate
	-- Hide blank widget
	if string.len(prvt.text) then
		prvt:show()
	else
		prvt:hide()
	end
end

-- Hook to intercept history additions
history.add_signal("add", function (uri, title)
        local domain = soup.parse_uri(uri).host
        domain = string.match(domain or "", "^www%.(.+)") or domain or "all"
        local no_hist = domain_props.all.enable_private_browsing or (domain_props[domain] or {}).enable_private_browsing
        repeat
            no_hist = no_hist or (domain_props["."..domain] or {}).enable_private_browsing
			no_hist = no_hist or util.table.hasitem(nohist, domain)
            domain = string.match(domain, "%.(.+)")
        until not domain
        return not no_hist
end)
