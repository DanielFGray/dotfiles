-- Global variables for luakit
globals = {
    homepage            = "luakit://bookmarks/",
    scroll_step         = 40,
    zoom_step           = 0.1,
    max_cmd_history     = 100,
    max_srch_history    = 100,
 -- http_proxy          = "192.168.150.1:8118",
    default_window_size = "800x600",

 -- Disables loading of hostnames from /etc/hosts (for large host files)
 -- load_etc_hosts      = false,
 -- Disables checking if a filepath exists in search_open function
 -- check_filepath      = false,
}

-- Make useragent
local _, arch = luakit.spawn_sync("uname -sm")
-- Only use the luakit version if in date format (reduces identifiability)
local lkv = string.match(luakit.version, "^(%d+.%d+.%d+)")
globals.useragent = string.format("Mozilla/5.0 (%s) AppleWebKit/%s+ (KHTML, like Gecko) WebKitGTK+/%s luakit%s",
    string.sub(arch, 1, -2), luakit.webkit_user_agent_version,
    luakit.webkit_version, (lkv and ("/" .. lkv)) or "")

-- Search common locations for a ca file which is used for ssl connection validation.
local ca_files = {
    -- $XDG_DATA_HOME/luakit/ca-certificates.crt
    luakit.data_dir .. "/ca-certificates.crt",
    "/etc/certs/ca-certificates.crt",
    "/etc/ssl/certs/ca-certificates.crt",
}
-- Use the first ca-file found
for _, ca_file in ipairs(ca_files) do
    if os.exists(ca_file) then
        soup.ssl_ca_file = ca_file
        break
    end
end

-- Change to stop navigation sites with invalid or expired ssl certificates
soup.ssl_strict = false

-- Set cookie acceptance policy
cookie_policy = { always = 0, never = 1, no_third_party = 2 }
soup.accept_policy = cookie_policy.always

-- List of search engines. Each item must contain a single %s which is
-- replaced by URI encoded search terms. All other occurances of the percent
-- character (%) may need to be escaped by placing another % before or after
-- it to avoid collisions with lua's string.format characters.
-- See: http://www.lua.org/manual/5.1/manual.html#pdf-string.format
search_engines = {
    ddg         = "https://duckduckgo.com/?q=%s",
    ix          = "https://ixquick.com/do/search?q=%s",
    gs          = "https://encrypted.google.com/search?q=%s",
    gis         = "https://encrypted.google.com/search?tbm=isch&q=%s",
    wiki        = "https://en.wikipedia.org/wiki/Special:Search?search=%s",
    yt          = "http://www.youtube.com/results?search_query=%s&aq=f",
    github      = "https://github.com/search?q=%s",
    imdb        = "http://imdb.com/find?s=all&q=%s",
    idioms      = "http://idioms.thefreedictionary.com/%s",
    acro        = "http://acronyms.thefreedictionary.com/%s",
    sf          = "http://sf.net/search/?words=%s",
    luakit      = "http://luakit.org/search/index/luakit?q=%s",
    nyaa        = "http://www.nyaa.eu/?page=search&cats=1_37&filter=0&term=%s",
    tosho       = "http://tokyotosho.info/search.php?terms=%s&type=1&size_min=&size_max=&username=",
    tiny        = "http://www.tineye.com/search?pluginver=bookmark_1.0&url=%s",
}

-- Set google as fallback search engine
search_engines.default = search_engines.gs
-- Use this instead to disable auto-searching
--search_engines.default = "%s"

-- Per-domain webview properties
-- See http://webkitgtk.org/reference/webkitgtk-WebKitWebSettings.html
--        enable_scripts          = false,
--        enable_plugins          = false,
--        user_stylesheet_uri     = "",
domain_props = {
    ["all"] = {
        enable_spell_checking   = true,
        spell_checking_languages = "en_US",
        enable_private_browsing = false,
    },
    [".4chan.org"] = {
        enable_scripts          = true,
        enable_plugins          = false,
--        enable_private_browsing = true,
    },
}

globals.history_blacklist = {
    ".4chan.org",
    "4chan.org",
}

-- vim: et:sw=4:ts=8:sts=4:tw=80
