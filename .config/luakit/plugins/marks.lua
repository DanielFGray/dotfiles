----------------------------------------------------------------
----------------------------------------------------------------

local ipairs = ipairs
local table = table
local string = string
local lousy = require "lousy"
local add_binds, add_cmds = add_binds, add_cmds
local new_mode, menu_binds = new_mode, menu_binds
local setmetatable = setmetatable

module("marks")

local cmd = lousy.bind.cmd
local buf = lousy.bind.buf

local marks = setmetatable({}, { __mode = "k"})

local set_mark = function (w, token)
	if not w.view then return end
	marks[w.view] = marks[w.view] or {}
	marks[w.view][token] = {}
	marks[w.view][token].y = w.view.scroll.y
	marks[w.view][token].x = w.view.scroll.x
	w:notify("Set mark " .. token .. ".")
end

local go_mark = function (w, mode, token, count)
	if not w.view then return end
	if token == "next" then
		-- TODO
		return
	elseif token == "prev" then
		-- TODO
		return
	else
		if marks[w.view] and marks[w.view][token] then
			w.view.scroll.y = marks[w.view][token].y
			if mode == "`" then
				w.view.scroll.x = marks[w.view][token].x
			end
			return
		end
	end
	w:error("No such mark (" .. token .. ")!")
end

add_binds("normal", {
	buf("^m[a-z]$", "set a mark", 
	function(w,b)
		local token = string.match(b, "^m(.)")
		set_mark(w, token)
	end),
	buf("^['`][a-z]$", "goto a mark", 
	function(w,b)
		local mode, token = string.match(b, "^(.)(.)")
		go_mark(w, mode, token)
	end),
	buf("^['`]%[$", "goto previous mark",
	function(w,b,m)
		local mode = string.match(b, "^(.)%[")
		local count = m.count or 1
		go_mark(w, mode, "prev", count)
	end),
	buf("^['`]%]$", "goto next mark",
	function(w,b,m)
		local mode = string.match(b, "^(.)%]")
		local count = m.count or 1
		go_mark(w, mode, "next", count)
	end),
})
