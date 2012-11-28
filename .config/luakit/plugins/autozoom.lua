--------------------------------------------------------
-- Auto save/apply zoom levels on a per-domain basis  --
-- (C) 2011 Roman Leonov <rliaonau@gmail.com>         --
-- (C) 2011 Mason Larobina <mason.larobina@gmail.com> --
--------------------------------------------------------

-- Get lua environment
local math = require "math"
local tonumber = tonumber
local string = string

-- Get luakit environment
local lousy = require "lousy"
local webview = webview
local capi = { luakit = luakit, sqlite3 = sqlite3 }
local esc = lousy.util.sql_escape
local globals = globals

module "plugins.autozoom"

-- Default zoom options
default_level = 1.0
zoom_full = false

-- Open database
db = capi.sqlite3{ filename = capi.luakit.data_dir .. "/autozoom.db" }
db:exec("PRAGMA synchronous = OFF;")

-- Create table
create_table = [[
CREATE TABLE IF NOT EXISTS by_domain (
    domain TEXT PRIMARY KEY,
    level FLOAT,
    full_content INTEGER
);]]
db:exec(create_table)

query_insert = [[INSERT OR REPLACE INTO by_domain
(domain, level, full_content)
VALUES(%s, %f, %d);]]

query_delete = "DELETE FROM by_domain WHERE domain=%s;"
query_obtain = "SELECT * FROM by_domain WHERE domain=%s;"
query_clean  = "DELETE FROM by_domain WHERE level = %f AND full_content = %d;"

-- Simple round function for lua-users wiki
local function round(num, idp)
    local mult = 10^(idp or 0)
    return math.floor(num * mult + 0.5) / mult
end

-- Set domain zoom settings
function set(domain, level, full_content)
    level, default_level = round(level or 1, 6), round(default_level or 1, 6)
    if (level ~= default_level) or (full_content ~= zoom_full) then
        db:exec(string.format(query_insert, esc(domain), level,
            full_content and 1 or 0))
    end
    -- Cleanup database
    db:exec(string.format(query_clean, default_level,
        zoom_full and 1 or 0))
end

local function get_domain(uri)
    local domain = lousy.uri.parse(uri).host
    return string.match(domain, "^www%.(.+)") or domain
end

webview.init_funcs.autozoom_setup = function (view)
    local function update(view)
        set(get_domain(view.uri), round(view:get_property("zoom-level"), 6), 
            view:get_property("full-content-zoom"))
    end
    -- Watch zoom changes
    view:add_signal("property::zoom-level", update)
    view:add_signal("property::full-content-zoom", update)

    -- Load zoom changes
    view:add_signal("load-status", function (view, status)
        if status ~= "first-visual" then return end
        local domain = get_domain(view.uri)
        local ret = db:exec(string.format(query_obtain, esc(domain)))
        if ret and ret[1] then
            view:set_property("zoom-level", tonumber(ret[1].level))
            view:set_property("full-content-zoom", ret[1].full_content == "1")
        else
            view:set_property("zoom-level", default_level)
            view:set_property("full-content-zoom", zoom_full)
        end
    end)
end
