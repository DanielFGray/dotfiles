------------------------------------------------------------
-- Dynamic useragent settings                             --
-- Written by lokichaos based upon proxy.lua by:          --
-- 
-- Copyright © Piotr Husiatyński <phusiatynski@gmail.com> --
------------------------------------------------------------

-- TODO
--  make per-tab widget & add hooks to update it
--  save ua in table
--  clean table for GC pruning
--  set behavior: set-current, set-all, set-new

-- Grab environment we need
local io = io
local os = os
local pairs = pairs
local ipairs = ipairs
local error = error
local string = string
local lousy = require "lousy"
local theme = theme
local unpack = unpack
local table = table
local capi = { luakit = luakit, soup = soup }
local webview = webview
local widget = widget
local window = window
local util = lousy.util
local globals = globals
-- Check for mode/bind functions
local add_binds, add_cmds = add_binds, add_cmds
local new_mode, menu_binds = new_mode, menu_binds
local setmetatable = setmetatable

module("plugin.useragent")

-- Store each webview's ua-name
local uas = {}
setmetatable(uas, { __mode = "k" })

--- Module global variables
local agents_file = capi.luakit.data_dir .. '/useragentmenu'

local useragents = {}
local realagent = { name = 0, uastring = globals.useragent }
local active = realagent
local default_name

-- Return ordered list of user agent names
function get_names()
    return lousy.util.table.keys(useragents)
end

-- Return ua string of user agent given by name
function get(name)
    return useragents[name]
end

--- Load user agents list from file
-- @param fd_name custom user agent storage of nil to use default
function load(fd_name)
    local fd_name = fd_name or agents_file
    if not os.exists(fd_name) then return end
    local strip = lousy.util.string.strip

    for line in io.lines(fd_name) do
        local status, name, uastring = string.match(line, "^(.)%s(.+)%s\"(.+)\"$")
        if uastring then
            name, uastring = strip(name), strip(uastring)
            if status == '*' then
                active = { uastring = uastring, name = name }
            end
            useragents[name] = uastring
        end
    end
    -- Set saved default ua string
    globals.useragent = active.uastring
    default_name = active.name
end

--- Save user agents list to file
-- @param fd_name custom user agent storage of nil to use default
function save(fd_name)
    local fd = io.open(fd_name or agents_file, "w")
    for name, uastring in pairs(useragents) do
        if uastring ~= "" then
            local status = (active.name == name and '*') or ' '
            fd:write(string.format("%s %s \"%s\"\n", status, name, uastring))
        end
    end
    io.close(fd)
end

--- Add new user agent to current list
-- @param name user agent configuration name
-- @param uastring user agent string
-- @param save_file do not save configuration if false
function set(name, uastring, save_file)
    local name = lousy.util.string.strip(name)
    if not string.match(name, "^([%w%p]+)$") then
        error("Invalid user agent name: " .. name)
    end
    useragents[name] = lousy.util.string.strip(uastring)
    if save_file ~= false then save() end
end

--- Delete selected user agent from list
-- @param name user agent name
-- TODO check all tabs
function del(name, w)
    local name = lousy.util.string.strip(name)
    if useragents[name] then
        -- if deleted user agent was the active one, use real/default uastring
        if name == active.name then
            active = realagent
        end
        useragents[name] = nil
        save()
    end
end

--- Set given user agent to active. Return true on success, else false
-- @param name user agents configuration name or nil to unset user agent.
function set_active(name)
    if name ~= 0 then
        local name = lousy.util.string.strip(name)
        if not useragents[name] then
            error("Unknown user agent: " .. name)
        end
        active = { name = name, uastring = useragents[name] }
    else
        active = realagent
    end
    save()
    return true
end

-- Create a user agent indicator widget and add it to the status bar
window.init_funcs.build_ua_indicator = function (w)
    local r = w.sbar.r
    r.uai = widget{type="label"}
    r.layout:pack(r.uai)
    r.layout:reorder(r.uai, 2)
    r.uai.fg = theme.useragenti_sbar_fg or theme.sbar_fg
    r.uai.font = theme.useragenti_sbar_font or theme.sbar_font
    w.tabs:add_signal("switch-page", function (nbook, view, idx)
        capi.luakit.idle_add(function() w:update_ua_indicator() return false end)
    end)
    w:update_ua_indicator()
end

-- Helper function to update text in user agent indicator
window.methods.update_ua_indicator = function (w)
    local name = uas[w.view] or (uas[w.view] == 0 and 0) or default_name
    local uai = w.sbar.r.uai
    if name ~= 0 then
        local text = string.format("(%s)", name)
        if uai.text ~= text then uai.text = text end
        uai:show()
    else
        uai:hide()
    end
end

new_mode("uagentmenu", {
    enter = function (w)
        -- Set all tab's uas entires
        for index = 1, w.tabs:count() do
            uas[w.tabs[index]] = uas[w.tabs[index]] or default_name
        end
        
        local afg = theme.useragent_active_menu_fg or theme.proxy_active_menu_fg
        local ifg = theme.useragent_inactive_menu_fg or theme.proxy_inactive_menu_fg
        local abg = theme.useragent_active_menu_bg or theme.proxy_active_menu_bg
        local ibg = theme.useragent_inactive_menu_bg or theme.proxy_inactive_menu_bg

        -- "Active" user agent, this is the one that is saved as a default between sessions
        local act_ua = uas[w.view]
        -- Add titlebar, and "Default" UA entry
        local dname = string.format("  %s %s%s", "Default Luakit User Agent",
                                     (active.name == 0  and "[Default]") or "",
                                     (default_name == 0 and "[Session]") or "")
        local rows = {{ "User Agent Name", " User Agent String", title = true },
            { dname, " " .. realagent.uastring or "", name = 0, uastring = '',
                fg = (act_ua == 0 and afg) or ifg,
                bg = (act_ua == 0 and abg) or ibg},}

        for _, name in ipairs(get_names()) do
            local uastring = get(name)
            local uaname = string.format("  %s %s%s", name,
                                         (active.name == name  and "[Default]") or "",
                                         (default_name == name and "[Session]") or "")
            table.insert(rows, {
                uaname, " " .. uastring,
                name = name, uastring = lousy.util.escape(uastring),
                fg = (act_ua == name and afg) or ifg,
                bg = (act_ua == name and abg) or ibg,
            })
        end
        w.menu:build(rows)
        w:notify("Use j/k to move, [d]elete, [e]dit, [a]dd, [S]et default, [s]et for all tabs, [n] set for new tabs, return to set for current tab.", false)
    end,

    leave = function (w)
        w.menu:hide()
    end,
})

local cmd = lousy.bind.cmd
add_cmds({
    cmd({"agent", "ua"}, "add new or select useragent",
        function (w, a)
            if not a then
                w:set_mode("uagentmenu")
            else
                local name, uastring = string.match(a, "(.+)%s\"(.+)\"")
                if name and uastring then
                    set(name, uastring)
                else
                    w:error("Bad usage. Correct format :agent <name> \"<agent string>\"")
                end
            end
        end),
 })


local ua_set = function(mode, ua, w)
    if mode == "current" then
        w.view.user_agent = ua.uastring or realagent.uastring
        uas[w.view] = ua.name
        if ua.name ~= 0 then
            w:notify(string.format("Set user agent on this tab to: %s (%s).", ua.name, ua.uastring))
        else
            w:notify("Set user agent for current tab to default.")
        end

    elseif mode == "newtabs" then
        globals.useragent = ua.uastring 
        default_name = ua.name
        if ua.name ~= 0 then
            w:notify(string.format("Set user agent for all new tabs to: %s (%s).", ua.name, ua.uastring))
        else
            w:notify("Set user agent for all new tabs to default Luakit.")
        end

    elseif mode == "all" then
        -- New Tabs will use this
        globals.useragent = ua.uastring
        default_name = ua.name
        -- Set user agent for all existing tabs
        for index = 1, w.tabs:count() do
            w.tabs[index].user_agent = ua.uastring
            uas[w.tabs[index]] = ua.name
        end
        if ua.name ~= 0 then
            w:notify(string.format("Set user agent for all tabs to: %s (%s).", ua.name, ua.uastring))
        else
            w:notify("Set user agent for all tabs to default.")
        end

    elseif mode == "default" then
       globals.useragent = ua.uastring
       default_name = ua.name
       set_active(ua.name)
       if ua.name ~= 0 then     
           w:notify(string.format("Set %s as default useragent (%s)", ua.name, ua.uastring))
       else
           w:notify("Unset default useragent, will default to real Luakit one.") 
       end

    end
    -- Update useragent statusbar widget
    w:update_ua_indicator()
end

local key = lousy.bind.key
add_binds("uagentmenu", lousy.util.table.join({
    -- Select user agent
    key({}, "Return",
        function (w)
            local row = w.menu:get()
            if row then
                w:set_mode()
                ua_set("current", row, w)
            end
        end),
    key({}, "S",
        function (w)
            local row = w.menu:get()
            if row then
                w:set_mode()
                ua_set("default", row, w)
            end
        end),
    key({}, "s",
        function (w)
            local row = w.menu:get()
            if row then
                w:set_mode()
                ua_set("all", row, w)
            end
        end),
    key({}, "n",
        function (w)
            local row = w.menu:get()
            if row then
                w:set_mode()
                ua_set("newtabs", row, w)
            end
        end),
    -- Delete user agent
    key({}, "d",
        function (w)
            local row = w.menu:get()
            if row and row.name then
                del(row.name)
                w.menu:del()
            end
        end),

    -- Edit user agent
    key({}, "e",
        function (w)
            local row = w.menu:get()
            if row and row.name then
                w:enter_cmd(string.format(":agent %s \"%s\"", row.name, row.uastring))
            end
        end),

    -- New user agent
    key({}, "a", function (w) w:enter_cmd(":agent ") end),

    -- Exit menu
    key({}, "q", function (w) w:set_mode() end),

}, menu_binds))

-- Initialize module
load()

-- vim: et:sw=4:ts=8:sts=4
