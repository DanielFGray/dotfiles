require('awful')
require('awful.autofocus')
require('awful.rules')
require('beautiful')
require('naughty')
require('vicious')
require('shifty')
require('debian.menu')

-- {{{ Error handling
if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = 'Oops, there were errors during startup!',
        text = awesome.startup_errors
    })
end

do
    local in_error = false
    awesome.add_signal('debug::error', function (err)
        if in_error then return end
        in_error = true
        naughty.notify({
            preset = naughty.config.presets.critical,
            title = 'Oops, an error happened!',
            text = err
        })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
local exec = awful.util.spawn
local terminal = 'urxvtc'
local term_cmd = terminal .. ' -e '
local editor = 'gvim -p '

function run_once(cmd)
    findme = cmd
    firstspace = cmd:find(' ')
    if firstspace then
        findme = cmd:sub(0, firstspace-1)
    end
    awful.util.spawn_with_shell('pgrep -u $USER -x ' .. findme .. ' > /dev/null || (' .. cmd .. ')')
 end

modkey = 'Mod4'
beautiful.init(awful.util.getdir('config') .. '/theme.lua')

layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}

-- Define if we want to use titlebar on all applications.
use_titlebar = true

-- Shifty configured tags.
shifty.config.tags = {
    w1 = {
        layout    = awful.layout.suit.floating,
        exclusive = false,
        position  = 1,
        init      = true,
        screen    = 1,
        slave     = true,
    },
    web = {
        layout    = awful.layout.suit.tile,
        exclusive = true,
        position  = 4,
        spawn     = browser,
    },
    mail = {
        layout    = awful.layout.suit.tile,
        exclusive = false,
        position  = 5,
        spawn     = mail,
        slave     = true
    },
    media = {
        layout    = awful.layout.suit.float,
        exclusive = false,
        position  = 8,
    },
    office = {
        layout   = awful.layout.suit.tile,
        position = 9,
    },
}

-- SHIFTY: application matching rules
-- order here matters, early rules will be applied first
shifty.config.apps = {
    {
        match = {
            'Vimperator',
            'Firefox',
            'luakit',
            'Nightly',
        },
        tag = 'web',
    },
    {
        match = {
            'Shredder.*',
            'Thunderbird',
            'mutt',
        },
        tag = 'mail',
    },
    {
        match = {
            'pcmanfm',
            'thunar',
            'nautilus',
        },
        slave = true
    },
    {
        match = {
            'OpenOffice.*',
            'Abiword',
            'Gnumeric',
        },
        tag = 'office',
    },
    {
        match = {
            'Mplayer.*',
            'Mirage',
            'qiv',
            'gimp',
            'gtkpod',
            'Ufraw',
            'easytag',
        },
        tag = 'media',
        nopopup = true,
    },
    {
        match = {
            'MPlayer',
            'Gnuplot',
            'gmrun',
            'xfrun4',
            'galculator',
        },
        float = true,
    },
    {
        match = {
            terminal,
        },
        slave = true,
    },
    {
        match = {''},
        honorsizehints = false,
        buttons = awful.util.table.join(
            awful.button({}, 1, function (c) client.focus = c; c:raise() end),
            awful.button({modkey}, 1, function(c)
                client.focus = c
                c:raise()
                awful.mouse.client.move(c)
            end),
            awful.button({modkey}, 3, awful.mouse.client.resize)
        )
    },
}

-- SHIFTY: default tag creation rules
-- parameter description
--  * floatBars : if floating clients should always have a titlebar
--  * guess_name : should shifty try and guess tag names when creating
--                 new (unconfigured) tags?
--  * guess_position: as above, but for position parameter
--  * run : function to exec when shifty creates a new tag
--  * all other parameters (e.g. layout, mwfact) follow awesome's tag API
shifty.config.defaults = {
    layout = awful.layout.suit.floating,
    ncol = 1,
    mwfact = 0.50,
    floatBars = true,
    guess_name = true,
    guess_position = true,
}
-- }}}

-- {{{ Menu
myawesomemenu = {
    { 'edit configs', editor .. '.config/awesome/rc.lua .config/awesome/theme.lua' },
    { 'restart',      awesome.restart },
    { 'quit',         awesome.quit }
}

powermenu = {
    { 'suspend',   'dbus-send --system --print-reply --dest="org.freedesktop.UPower" /org/freedesktop/UPower org.freedesktop.UPower.Suspend' },
    { 'hibernate', 'dbus-send --system --print-reply --dest="org.freedesktop.UPower" /org/freedesktop/UPower org.freedesktop.UPower.Hibernate' },
    { 'reboot',    'dbus-send --system --print-reply --dest="org.freedesktop.ConsoleKit" /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.Restart' },
    { 'halt',      'dbus-send --system --print-reply --dest="org.freedesktop.ConsoleKit" /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.Stop' },
}

mnuCompositing = {
    { 'stop',  'killall compton' },
    { 'start', 'compton -cC -fF -I 0.065 -O 0.065 -D 6 -m 0.8 -G -b' },
}
mnuMain = awful.menu({ items = {
    { 'terminal', terminal } ,
    { 'editor',   editor },
    { 'browser',  'firefox' },
    { 'thunar',   'thunar' },
    { 'gvim',     'gvim' },
    { 'luakit',   'luakit' },
    { 'ncmpcpp',  term_cmd .. 'ncmpcpp' },
    { 'htop',     term_cmd .. 'htop' },
    { 'weechat',  term_cmd .. 'weechat-curses' },
    { 'rtorrent',  term_cmd .. 'rtorrent' },
    { 'gimp',     'gimp' },
    { 'composite', mnuCompositing },
    { '', '' },
    { 'Debian',   debian.menu.Debian_menu.Debian },
    { 'awesome',  myawesomemenu },
    { 'power',    powermenu },
}})
mylauncher = awful.widget.launcher({
    image = image(beautiful.awesome_icon),
    menu = mnuMain
})
-- }}}

--  {{{ Wibox
datewidget = widget({ type = 'textbox' })
vicious.register(datewidget, vicious.widgets.date, ' %a %b %d %Y  %l:%M:%S ', 1)

mysystray = widget({ type = 'systray', align = 'left' })

mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
    awful.button({}, 1,       awful.tag.viewonly),
    awful.button({modkey}, 1, awful.client.movetotag),
    awful.button({}, 3,       function(tag) tag.selected = not tag.selected end),
    awful.button({modkey}, 3, awful.client.toggletag),
    awful.button({}, 4,       awful.tag.viewnext),
    awful.button({}, 5,       awful.tag.viewprev)
)

mytasklist = {}
mytasklist.buttons = awful.util.table.join(
    awful.button({ }, 1, function (c)
        if c == client.focus then
            c.minimized = true
        else
            if not c:isvisible() then
                awful.tag.viewonly(c:tags()[1])
            end
            client.focus = c
            c:raise()
        end
    end),
    awful.button({ }, 3, function ()
        if instance then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ width=250 })
        end
    end),
    awful.button({ }, 4, function ()
        awful.client.focus.byidx(1)
        if client.focus then client.focus:raise() end
    end),
    awful.button({ }, 5, function ()
        awful.client.focus.byidx(-1)
        if client.focus then client.focus:raise() end
    end)
)

spacer       = widget({ type = 'textbox'  })
spacer.text  = ' <span color="' .. theme.colors.blue .. '">|</span> '
space        = widget({ type = 'textbox' })
space.text   = ' '

mpdicon = widget({ type = 'imagebox', align = 'left' })
mpdicon.image = image(awful.util.getdir('config') .. '/icons/music.png')
mpdwidget = widget({ type = 'textbox' })
vicious.register(mpdwidget, vicious.widgets.mpd,
    function (widget, args)
        if args["{state}"] == ("Stop" or "N/A") then 
            mpdicon.visible = false
            return ''
        else 
            mpdicon.visible = true
            return args["{Artist}"] .. '<span color="' .. theme.colors.base0 .. '"> - </span>' .. args["{Title}"] .. spacer.text
        end
    end, 5)
mpdwidget:buttons(
    awful.util.table.join(
        awful.button({}, 1, function () awful.util.spawn('mpc toggle', false) end),
        awful.button({}, 2, function () awful.util.spawn(term_cmd .. 'ncmpcpp') end),
        awful.button({}, 4, function () awful.util.spawn('mpc prev', false) end),
        awful.button({}, 5, function () awful.util.spawn('mpc next', false) end)
    )
)

cpuicon = widget({ type = 'imagebox', align = 'left' })
cpuicon.image = image(awful.util.getdir('config') .. '/icons/cpu.png')
cpuwidget = widget({ type = 'textbox' })
vicious.register(cpuwidget, vicious.widgets.cpu, '$1% ', .5)

memicon = widget({ type = 'imagebox', align = 'left' })
memicon.image = image(awful.util.getdir('config') .. '/icons/mem.png')
memwidget = widget({ type = 'textbox' })
vicious.register(memwidget, vicious.widgets.mem,
    '$1% <span color="' .. theme.colors.base0 .. '">(</span>$2<span color="' .. theme.colors.base0 .. '">/$3)</span>', 5)

sensicon = widget({ type = 'imagebox', align = 'left' })
sensicon.image = image(awful.util.getdir('config') .. '/icons/temp.png')
senswidget = widget({ type = 'textbox' })
vicious.register(senswidget, vicious.widgets.thermal,
    function (widget, args)
        return args[1] .. '<span color="' .. theme.colors.base0 .. '">°C</span> '
    end, 15, "thermal_zone0")

baticon = widget({ type = 'imagebox' })
baticon.image = image(awful.util.getdir('config') .. '/icons/bat.png')
batwidget = widget({ type = 'textbox' })
vicious.register(batwidget, vicious.widgets.bat, '$1$2% ', 30, 'BAT1')

wifiicon = widget({ type = 'imagebox', align = 'left' })
wifiicon.image = image(awful.util.getdir('config') .. '/icons/wifi.png')
wifiwidget = widget({ type = 'textbox' })
vicious.register(wifiwidget, vicious.widgets.wifi,
    function (widget, args)
        if args['{link}'] == 0 then
            wifiicon.visible = false
            return ''
        else
            wifiicon.visible = true
            return string.format("%i%% ", args["{link}"]/70*100)
        end
    end, 4, "wlan0")

netupicon = widget({ type = 'imagebox', align = 'left' })
netupicon.image = image(awful.util.getdir('config') .. '/icons/up.png')
netupwidget = widget({ type = 'textbox' })
vicious.register(netupwidget, vicious.widgets.net,
    function (widget, args)
        if args["{wlan0 carrier}"] == 1 then
            return args["{wlan0 up_kb}"] .. 'k<span color="' .. theme.colors.base0 .. '">/' .. args["{wlan0 tx_mb}"] .. 'M</span>'
        elseif args["{eth0 carrier}"] == 1 then
            return args["{eth0 up_kb}"] .. 'k<span color="' .. theme.colors.base0 .. '">/' .. args["{eth0 tx_mb}"] .. 'M</span>'
        end
    end, 3)

netdownicon = widget({ type = 'imagebox', align = 'left' })
netdownicon.image = image(awful.util.getdir('config') .. '/icons/down.png')
netdownwidget = widget({ type = 'textbox' })
vicious.register(netdownwidget, vicious.widgets.net, 
    function (widget, args)
        if args["{wlan0 carrier}"] == 1 then
            return args["{wlan0 down_kb}"] .. 'k<span color="' .. theme.colors.base0 .. '">/' .. args["{wlan0 rx_mb}"] .. 'M</span>'
        elseif args["{eth0 carrier}"] == 1 then
            return args["{eth0 down_kb}"] .. 'k<span color="' .. theme.colors.base0 .. '">/' .. args["{eth0 rx_mb}"] .. 'M</span>'
        end
    end, 3)

mytasklist.buttons = awful.util.table.join(
    awful.button({}, 1, function(c)
        if not c:isvisible() then
            awful.tag.viewonly(c:tags()[1])
        end
        client.focus = c
        c:raise()
    end),
    awful.button({}, 3, function()
        if instance then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({width=250})
        end
    end),
    awful.button({}, 4, function()
        awful.client.focus.byidx(1)
        if client.focus then client.focus:raise() end
    end),
    awful.button({}, 5, function()
        awful.client.focus.byidx(-1)
        if client.focus then client.focus:raise() end
    end))

for s = 1, screen.count() do
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
        awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
        awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
        awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
        awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    mytasklist[s] = awful.widget.tasklist(function(c)
        return awful.widget.tasklist.label.currenttags(c, s)
        end, mytasklist.buttons)

    mywibox[s] = {}
    mywibox[s][1] = awful.wibox({ position = 'top',    screen = s, height = 16 })
    mywibox[s][2] = awful.wibox({ position = 'bottom', screen = s, height = 16 })
    mywibox[s][1].widgets = {
        mylayoutbox[s],
        mytaglist[s],
        mypromptbox[s],
        {
            space,
            memwidget,memicon,
            batwidget,baticon, --I wish my battery worked ):
            senswidget,sensicon,
            cpuwidget,cpuicon,
            spacer,
            netupwidget,netupicon,
            space,
            netdownwidget,netdownicon,
            wifiwidget,wifiicon,
            mpdwidget,mpdicon,
            layout = awful.widget.layout.horizontal.rightleft
        },
        layout = awful.widget.layout.horizontal.leftright
   }
   mywibox[s][2].widgets = {
        datewidget,
        s == 1 and mysystray or nil,
        {
            mylauncher,
            mytasklist[s],
            layout = awful.widget.layout.horizontal.flex
        },
        layout = awful.widget.layout.horizontal.rightleft
   }
end

shifty.taglist = mytaglist
shifty.init()
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({}, 3, function() mnuMain:toggle() end),
    awful.button({}, 4, awful.tag.viewnext),
    awful.button({}, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ }, 'XF86AudioRaiseVolume', function () exec('amixer -q set Master 5%+') end),
    awful.key({ }, 'XF86AudioLowerVolume', function () exec('amixer -q set Master 5%-') end),
    awful.key({ }, 'XF86AudioMute',        function () exec('amixer -q set Master toggle') end),
    awful.key({ }, 'XF86AudioPlay',        function () exec('mpc -q toggle', false) end),
    awful.key({ }, 'XF86AudioStop',        function () exec('mpc -q stop', false) end),
    awful.key({ }, 'XF86AudioNext',        function () exec('mpc -q next', false) end),
    awful.key({ }, 'XF86AudioPrev',        function () exec('mpc -q prev', false) end),
    awful.key({modkey}, 'Left',            awful.tag.viewprev),
    awful.key({modkey}, 'Right',           awful.tag.viewnext),
    awful.key({modkey}, 'Escape',          awful.tag.history.restore),
    awful.key({modkey, 'Shift'}, 'd',      shifty.del),
    awful.key({modkey, 'Shift'}, 'n',      shifty.send_prev),
    awful.key({modkey}, 'n',               shifty.send_next),
    awful.key({modkey, 'Control'}, 'n',    function()
                                               local t = awful.tag.selected()
                                               local s = awful.util.cycle(screen.count(), t.screen + 1)
                                               awful.tag.history.restore()
                                               t = shifty.tagtoscr(s, t)
                                               awful.tag.viewonly(t)
                                           end),
    awful.key({modkey}, 'a',               shifty.add),
    awful.key({modkey}, 'r',               shifty.rename),
    awful.key({modkey, 'Shift'}, 'a',      function()
                                               shifty.add({nopopup = true})
                                           end),
    awful.key({modkey}, 'j',               function()
                                               awful.client.focus.byidx(1)
                                               if client.focus then client.focus:raise() end
                                           end),
    awful.key({modkey}, 'k',               function()
                                               awful.client.focus.byidx(-1)
                                               if client.focus then client.focus:raise() end
                                           end),
    awful.key({modkey}, 'w',               function() mnuMain:show(true) end),
    awful.key({modkey, 'Shift'}, 'j',      function() awful.client.swap.byidx(1) end),
    awful.key({modkey, 'Shift'}, 'k',      function() awful.client.swap.byidx(-1) end),
    awful.key({modkey, 'Control'}, 'j',    function() awful.screen.focus(1) end),
    awful.key({modkey, 'Control'}, 'k',    function() awful.screen.focus(-1) end),
    awful.key({modkey}, 'u',               awful.client.urgent.jumpto),
    awful.key({modkey}, 'Tab',             function()
                                               awful.client.focus.history.previous()
                                               if client.focus then
                                                   client.focus:raise()
                                               end
                                           end),
    awful.key({modkey}, 'Return',          function() exec(term_cmd .. 'tmux') end),
    awful.key({modkey, 'Control'}, 'r',    awesome.restart),
    awful.key({modkey, 'Shift'}, 'q',      awesome.quit),
    awful.key({modkey}, 'l',               function() awful.tag.incmwfact(0.05) end),
    awful.key({modkey}, 'h',               function() awful.tag.incmwfact(-0.05) end),
    awful.key({modkey, 'Shift'}, 'h',      function() awful.tag.incnmaster(1) end),
    awful.key({modkey, 'Shift'}, 'l',      function() awful.tag.incnmaster(-1) end),
    awful.key({modkey, 'Control'}, 'h',    function() awful.tag.incncol(1) end),
    awful.key({modkey, 'Control'}, 'l',    function() awful.tag.incncol(-1) end),
    awful.key({modkey}, 'space',           function() awful.layout.inc(layouts, 1) end),
    awful.key({modkey, 'Shift'}, 'space',  function() awful.layout.inc(layouts, -1) end),
    awful.key({modkey}, 'F4',              function()
                                               awful.prompt.run({prompt = 'Run Lua code: '},
                                               mypromptbox[mouse.screen].widget,
                                               awful.util.eval, nil,
                                               awful.util.getdir('cache') .. '/history_eval')
                                           end),
    awful.key({modkey, 'Mod1'}, 'l',       function () awful.util.spawn('xscreensaver-command --lock') end),
    awful.key({modkey}, 'F1',              function ()
                                               local f_reader = io.popen( 'dmenu_path | dmenu -b -nb "' .. beautiful.bg_normal .. '" -nf "' .. beautiful.fg_normal .. '" -sb "' .. beautiful.colors.blue .. '"')
                                               local command = assert(f_reader:read('*a'))
                                               f_reader:close()
                                               awful.util.spawn(command)
                                           end)
)

clientkeys = awful.util.table.join(
    awful.key({modkey}, 'f',                 function(c) c.fullscreen = not c.fullscreen end),
    awful.key({modkey, 'Shift'}, 'c',        function(c) c:kill() end),
    awful.key({modkey, 'Control'}, 'space',  awful.client.floating.toggle),
    awful.key({modkey, 'Control'}, 'Return', function(c) c:swap(awful.client.getmaster()) end),
    awful.key({modkey}, 'o',                 awful.client.movetoscreen),
    awful.key({modkey, 'Shift'}, 'r',        function(c) c:redraw() end),
    awful.key({modkey}, 't',                 awful.client.togglemarked),
    awful.key({modkey}, 'm',                 function(c)
                                                 c.maximized_horizontal = not c.maximized_horizontal
                                                 c.maximized_vertical   = not c.maximized_vertical
                                             end)
)

shifty.config.clientkeys = clientkeys
shifty.config.modkey = modkey

--}}}

for i = 1, (shifty.config.maxtags or 9) do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({modkey}, i, function()
            local t =  awful.tag.viewonly(shifty.getpos(i))
            end),
        awful.key({modkey, 'Control'}, i, function()
            local t = shifty.getpos(i)
            t.selected = not t.selected
            end),
        awful.key({modkey, 'Control', 'Shift'}, i, function()
            if client.focus then
                awful.client.toggletag(shifty.getpos(i))
            end
            end),
        awful.key({modkey, 'Shift'}, i, function()
            if client.focus then
                t = shifty.getpos(i)
                awful.client.movetotag(t)
                awful.tag.viewonly(t)
            end
        end))
    end

root.keys(globalkeys)

client.add_signal('focus', function(c) if not awful.client.ismarked(c) then c.border_color = beautiful.border_focus end end)
client.add_signal('unfocus', function(c) if not awful.client.ismarked(c) then c.border_color = beautiful.border_normal end end)

exec     ('xrdb -merge /home/dan/.Xresources')
exec     ('synclient TapButton1=1')
run_once ('urxvtd')
run_once ('mpd')
run_once ('thunar --daemon')
run_once ('xscreensaver -no-splash')
run_once ('xfce4-power-manager')
run_once ('clipit')
run_once ('nm-applet')
