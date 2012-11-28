----------------------------------------------------------------
-- Multi-Session save/restore Plugin                          --
----------------------------------------------------------------

local ipairs = ipairs
local tostring = tostring
local lfs = lfs
local os = os
local io = io
local table = table
local string = string
local unpack = unpack
local lousy = require "lousy"
local util = lousy.util
local luakit = luakit
local window = window
local add_binds, add_cmds = add_binds, add_cmds
local new_mode, menu_binds = new_mode, menu_binds
local cmd = lousy.bind.cmd
local buf = lousy.bind.buf

module("plugins.multisession")

local sessions_dir = luakit.data_dir .. "/sessions"

local rm = function (file)
    luakit.spawn(string.format("rm %q", file))
end

local session_save = function (w, name)
    if not name then return end
    local fpath = sessions_dir .. "/" .. (name or "")
    -- Save all given windows uris to file.
    local lines = {}
    -- Save tabs from all the given window, keep the window-index to keep
    -- comptability with default sessions format
    local current = w.tabs:current()
    for ti, tab in ipairs(w.tabs.children) do
        table.insert(lines, string.format("%d\t%d\t%s\t%s", 1, ti,
                     tostring(current == ti), tab.uri))
    end
    -- Only save a non-empty session
    if #lines > 0 then
        local fh = io.open(fpath, "w")
        fh:write(table.concat(lines, "\n"))
        io.close(fh)
    else
        rm(session.file)
    end
end

local session_load = function (name)
    local fpath = sessions_dir .. "/" .. (name or "")
    if not name or not os.exists(fpath) then return end
    local ret = {}

    -- Read file
    local lines = {}
    local fh = io.open(fpath, "r")
    for line in fh:lines() do table.insert(lines, line) end
    io.close(fh)

    -- Parse session file, again, ignore the window-index, keeping for
    -- compatibility
    for _, line in ipairs(lines) do
        local wi, ti, current, uri = unpack(util.string.split(line, "\t"))
        current = (current == "true")
        table.insert(ret, {uri = uri, current = current})
    end

    return (#ret > 0 and ret) or nil
end

-- Create a new window and open all tabs in the session in it
local session_restore = function (name)
    win = session_load(name)
    if not win or #win == 0 then return end

    -- Spawn windows
    local w
    for _, item in ipairs(win) do
        if not w then
                w = window.new({item.uri})
        else
            w:new_tab(item.uri, item.current)
        end
    end
    -- Save Session Name in window
    w.session_name = name
    return w
end

-- Opens all tabs in named session in current window
local session_append = function (w, name)
    ses = session_load(name)
    if not ses or #ses == 0 then return false end
    for _, item in ipairs(ses) do
        w:new_tab(item.uri, item.current)
    end
    return true
end

local session_del = function (name)
    if not name then return end
    local fpath = sessions_dir .. "/" .. (name or "")
    if not os.exists(fpath) then return false end
    rm(fpath)
    return true
end

local load = function ()
        local curdir = lfs.currentdir()
        if not lfs.chdir(sessions_dir) then
            lfs.mkdir(sessions_dir)
        else
            lfs.chdir(curdir)
        end
end

add_cmds({
    cmd("session", "view list of sessions",   function (w) w:set_mode("sessionmenu") end),
    cmd({"session-write", "sw"}, "save a session to file", 
        function (w, a)
            local name = util.string.strip(a) or w.session_name or "default"
            -- Set name of session to name
            w.session_name = name
            session_save(w, name)
            w:notify("Saved " .. tostring(w.tabs:count()) .. " tabs to session " .. name .. ".")
        end),
    -- Modified :write to support named sessions
    cmd("write", "Save current session.",
        function (w, a)
            local name = util.string.strip(a) or w.session_name
            if name then
                session_save(w, name)
            else
                w:save_session()
            end
        end),
    cmd({"session-delete", "sd"}, "delete a saved session",
        function(w, a)
            local name = util.string.strip(a)
            if session_del(name) then
                w:notify("Deleted session " .. name .. ".")
            else
                w:error("No saved session named " .. name .."!")
            end
        end),
    cmd({"session-restore", "sr"}, "load a saved session in a new window",
        function(w, a)
            local name = util.string.strip(a) or "default"
            if not session_restore(name) then
                w:error("Unable to restore session " .. name .. "!")
            end
        end),
    cmd({"session-open", "so"}, "open a saved session in new tabs in current window",
        function(w, a)
            local name = util.string.strip(a) or "default"
            if not session_append(w, name) then
                w:error("Unable to open session " .. name .. "!")
            else
                w:notify("Appended session " .. name .. " to tabs.")
            end
        end),
})

add_binds("normal", {
    buf("^sm$", "open list of saved sessions",
        function(w) w:set_mode("sessionmenu") end),
    -- Modified ZZ to save any named session to the multi-session file rather
    -- than the default session file
    buf("^ZZ$", "Quit and save the session.",
        function (w)
            if w.session_name then
                session_save(w, w.session_name)
            else
                w:save_session()
            end
            w:close_win()
        end),

})

new_mode("sessionmenu", {
    enter = function (w)
        local rows = {{"Saved Sessions (# of tabs)", title = true}}

        for filename in lfs.dir(sessions_dir) do
            if not string.match(filename, "^%.-$") then
                local fh = io.open(sessions_dir .. "/" .. filename)
                local tabcnt = 0
                for _ in fh:lines() do tabcnt = tabcnt + 1 end
                io.close(fh)
                table.insert(rows, {string.format(" %s (%d)", filename, tabcnt), name = filename})
            end
        end
        if #rows == 1 then
            table.insert(rows, {"No saved sessions!"})
        end
        w.menu:build(rows)
        w:notify("Use j/k to move, d to delete a session, t to append session to current window, Enter to open session (in new window)", false)
    end,

    leave = function (w)
        w.menu:hide()
    end,
})

local key = lousy.bind.key
add_binds("sessionmenu", lousy.util.table.join({
    key({}, "Return", function (w)
        local row = w.menu:get()
        if row and row.name then
            w:set_mode()
            session_restore(row.name)
        end
    end),

    key({}, "t", function (w)
        local row = w.menu:get()
        if row and row.name then
            w:set_mode()
            session_append(w, row.name)
        end
    end),

    key({}, "d", function (w)
        local row = w.menu:get()
        if row and row.name then
            w.menu:del()
            session_del(row.name)
        end
    end),

    -- Exit menu
    key({}, "q", function (w) w:set_mode() end),

}, menu_binds))

load()
-- vim: et:sw=4:ts=8:sts=4:tw=80
