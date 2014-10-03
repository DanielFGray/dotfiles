-- Module for checking public suffixes and tlds
local string = string
local table = table
local util = require("lousy.util")
local io = io
local tldlist = require("tldlist")

local print = print
local ipairs = ipairs
module("tld")

gettld = function (host)
	if host and host ~= "" then
		local phost = host
		while phost do
			if tldlist.phost[phost] then
				return phost
			end
			p = string.match(phost, "(.-)%.")
			phost = string.match(phost, "%.(.*)")
			if phost and tldlist.phost["*." .. phost] then
				if tldlist.phost["!" .. p .. "." .. phost] then
					return phost
				else
					return p .. ".".. phost
				end
			end
		end
	end
end

getdomain = function (host)
	if not host or host == "" then
		return nil
	elseif string.match(host, "^[0-9%.]-$") then
		return host
	else
		local tl = gettld(host)
		if tl == host then
			return nil
		elseif tl then
			local hb = util.table.reverse(util.string.split(host, "%."))
			local n = #(util.string.split(tl, "%.") or {}) + 1
			return hb[n] .. "." .. tl
		else
			return host
		end
	end
end
