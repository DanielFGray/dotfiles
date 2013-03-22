local key, buf, but = lousy.bind.key, lousy.bind.buf, lousy.bind.but
local cmd, any = lousy.bind.cmd, lousy.bind.any
local webview = webview

-- Util aliases
local match, join = string.match, lousy.util.table.join
local strip, split = lousy.util.string.strip, lousy.util.string.split

-- Globals or defaults that are used in binds
local scroll_step = globals.scroll_step or 20
local zoom_step = globals.zoom_step or 0.1

-- Add binds to a mode
function add_binds(mode, binds, before)
    assert(binds and type(binds) == "table", "invalid binds table type: " .. type(binds))
    mode = type(mode) ~= "table" and {mode} or mode
    for _, m in ipairs(mode) do
        local mdata = get_mode(m)
        if mdata and before then
            mdata.binds = join(binds, mdata.binds or {})
        elseif mdata then
            mdata.binds = mdata.binds or {}
            for _, b in ipairs(binds) do table.insert(mdata.binds, b) end
        else
            new_mode(m, { binds = binds })
        end
    end
end

-- Add commands to command mode
function add_cmds(cmds, before)
    add_binds("command", cmds, before)
end


-- Call dmenu w/ history listing
webview.methods.browse_hist_dmenu = function( view, w )
    local scripts_dir = luakit.data_dir .. "/scripts" 
    local hist_file = luakit.data_dir .. "/history.db" 
    local query = "\\\"select uri, title, datetime(last_visit,'unixepoch') from history order by last_visit DESC;\\\"" 
    local dmenu = "dmenu -l 10" 
    -- AFAIK, luakit will urlencode spaces in uri's so this crude cut call should work fine.
    local fh = io.popen( "sh -c \"echo " .. query .. " | sqlite3 " .. hist_file .. " | sed 's#|#  #' | " .. dmenu .. " | cut -d' ' -f1\"" , "r" )
    local selection = fh:read( "*a" )
    fh:close()
    if selection ~= "" then w:navigate( selection ) end
end

-- External Editor, blocking
add_binds("insert", {
     key({"Mod1"}, "e", function (w)
--        local s = w.view:eval_js("document.activeElement.value")
--        local n = "/tmp/" .. os.time()
--        local f = io.open(n, "w")
--        f:write(s)
--        f:flush()
--        f:close()
--        luakit.spawn_sync('urxvtc -e vim -c "set spell" "' .. n .. '"')
--        f = io.open(n, "r")
--        s = f:read("*all")
--        f:close()
--        s = s:gsub("^%s*(.-)%s*$", "%1")
--        s = string.format("%q", s):sub(2, -2)
--        s = s:gsub("\\\n", "\\n")
--        w.view:eval_js("document.activeElement.value = '" .. s .. "'")

        local editor = "urxvt -e vi -c 'set spell'" 
        local dir = "/home/dan/tmp/" 
        local time = os.time()
        local file = dir .. "luakitvim_" .. time
        local marker = "luakit_extedit_" .. time
        local function editor_callback(exit_reason, exit_status)
            f = io.open(file, "r")
            s = f:read("*all")
            f:close()
            -- Strip the string
            s = s:gsub("^%s*(.-)%s*$", "%1")
            -- Escape it but remove the quotes
            s = string.format("%q", s):sub(2, -2)
            -- lua escaped newlines (slash+newline) into js newlines (slash+n)
            s = s:gsub("\\\n", "\\n")
            w.view:eval_js(string.format([=[
                var e = document.getElementsByClassName('%s');
                if(1 == e.length && e[0].disabled){
                    e[0].focus();
                    e[0].value = "%s";
                    e[0].disabled = false;
                    e[0].className = e[0].className.replace(/\b %s\b/,'');
                }
            ]=], marker, s, marker))
        end

        local s = w.view:eval_js(string.format([=[
            var e = document.activeElement;
            if(e && (e.tagName && 'TEXTAREA' == e.tagName || e.type && 'text' == e.type)){
                var s = e.value;
                e.className += " %s";
                e.disabled = true;
                e.value = '%s';
                s;
            }else 'false';
        ]=], marker, file))
        if "false" ~= s then
            local f = io.open(file, "w")
            f:write(s)
            f:flush()
            f:close()
            luakit.spawn(string.format("%s %q", editor, file), editor_callback)
        end
    end),
})

add_binds("normal", {
    -- Scroll to top & refresh
    buf("^gr$", "Go to the top of the document and reload.",
	    function (w, b, m) w:scroll{ ypct = m.count } w:reload()     end, {count = 0}),
    buf("^gR$", "Go to the top of the document and reload.",
	    function (w, b, m) w:scroll{ ypct = m.count } w:reload(true) end, {count = 0}),
    buf("^gl$", "dmenu-based history search",
		function (w)       w:browse_hist_dmenu() end),
    key({"Control"}, "space", "Clear search highlighting.",
	    function (w) w:clear_search() end),
    --key({"Mod1"}, "e", function (w) external_edit(w) end),
})
