--local gears =             require("gears")
local awful =             require("awful")
local awful_autofocus =   require("awful.autofocus")
local wibox =             require("wibox")
local beautiful =         require("beautiful")
local naughty =           require("naughty")
local menubar =           require("menubar")
local shifty =            require("shifty")
local vicious =           require("vicious")
--local freedesktop_utils = require("freedesktop.utils")
--local freedesktop_menu =  require("freedesktop.menu")

-- {{{ Error handling
if awesome.startup_errors then
	naughty.notify({
		preset = naughty.config.presets.critical,
		title = "Oops, there were errors during startup!",
		text = awesome.startup_errors
	})
end

do
	local in_error = false
	awesome.connect_signal("debug::error", function(err)
		if in_error then return end
		in_error = true
		naughty.notify({
			preset = naughty.config.presets.critical,
			title = "Oops, an error happened!",
			text = err })
		in_error = false
	end)
end
-- }}}

-- {{{ Variable definitions
modkey =            "Mod4"
configdir =         awful.util.getdir("config").."/"
homedir =           os.getenv("HOME").."/"
exec =              awful.util.spawn
sexec =             awful.util.spawn_with_shell
terminal =          "urxvtcd "
term_cmd =          terminal.."-e "
editor =            term_cmd.."vim -p "
browser =           "luakit "
filemanager =       "nautilus "
mpdclient =         "sonata "
--mpdclient =         term_cmd.."ncmpcpp"
--wirelessinterface = "wlan0"
wirelessinterface = "wlp8s0"
wiredinterface =    "eth0"
beautifultheme =     "/home/dan/.config/.awesome/".."themes/dfg/"
--beautifultheme =     configdir.."themes/dfg/"

beautiful.init(beautifultheme.."theme.lua")

function run_once(cmd)
	local findme = cmd
	local firstspace = cmd:find(' ')
	if firstspace then
		findme = cmd:sub(0, firstspace - 1)
	end
	sexec('pgrep -u $USER -x '..findme..' > /dev/null || ('..cmd..')')
end

exec     ("xrdb -load "..homedir..".Xresources")
run_once ("urxvtd -q -f")
run_once ("compton")
run_once ("mpd")
--run_once ("thunar --daemon")
run_once ("xscreensaver -no-splash")
--run_once ("xfce4-power-manager")
run_once ("clipit")
run_once ("nm-applet")
run_once ("volti")

local layouts = {
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

shifty.config.tags = {
	web = {
		layout    = awful.layout.suit.max,
		exclusive = true,
		position  = 1,
--		init      = true,
		slave     = false,
		spawn     = browser,
	},
	term = {
		layout    = awful.layout.suit.tile.top,
		position  = 2,
		exclusive = true,
		mwfact    = 0.75,
--		init      = true,
		spawn     = term_cmd.."sh "..homedir.."bin/tmuxsession2 ;"..term_cmd.."sh "..homedir.."bin/tmuxsession",
--		slave     = true
	},
	books = {
		layout    = awful.layout.suit.tile,
--		position  = 3,
		spawn     = filemanager.."/pr0n/books",
		exclusive = false,
	},
	audio = {
		layout    = awful.layout.suit.tile,
--		position  = 4,
		spawn     = mpdclient.." && pavucontrol",
		exclusive = false,
	},
--	office = {
--		layout   = awful.layout.suit.tile,
--		position = 9,
--	},
}

shifty.config.apps = {
	{
		match = {
			"gmrun",
			"gsimplecal",
			"xfrun4",
		},
		slave = true,
		float = true,
	},
	{
		match = {
			"Vimperator",
			"Firefox",
			"luakit",
			"Nightly",
			"uzbl",
		},
		tag = "web",
	},
	{
		match = {
			"Shredder.*",
			"Thunderbird",
			"mutt",
		},
		tag = "mail",
	},
	{
		match = {
			"pcmanfm",
			"thunar",
			"nautilus",
		},
		slave = true
	},
	{
		match = {
			"OpenOffice.*",
			"Abiword",
			"Gnumeric",
		},
		tag = "office",
	},
	{
		match = {
			"Mplayer.*",
			"Mirage",
			"qiv",
			"gimp",
			"gtkpod",
			"Ufraw",
			"easytag",
		},
		tag = "media",
	},
	{
		match = {
			"MPlayer",
			"Gnuplot",
			"galculator",
		},
		float = true,
	},
	{
		match = {
			terminal,
			"xterm",
			"urxvt",
		},
		tag = "term",
		slave = true,
	},
	{
		match = {""},
		honorsizehints = false,
		buttons = awful.util.table.join(
			awful.button({}, 1, function(c) client.focus = c; c:raise() end),
			awful.button({modkey}, 1, function(c)
				client.focus = c
				c:raise()
				awful.mouse.client.move(c)
			end),
			awful.button({modkey}, 3, awful.mouse.client.resize)
		)
	},
}

shifty.config.defaults = {
	layout = awful.layout.suit.floating,
	ncol = 1,
	mwfact = 0.60,
	floatBars = true,
	guess_name = true,
	guess_position = true,
}
-- }}}

-- {{{ Menu
mnuAwesome = {
	{"edit configs", editor..configdir.."rc.lua "..beautifultheme.."theme.lua"},
	{"restart", awesome.restart},
	{"quit", awesome.quit}
}

mnuCompositing = {
	{"stop",  "pkill compton"},
	{"start", "compton"},
}

mnuApps = {}
--for _, item in ipairs(freedesktop_menu.new()) do table.insert(mnuApps, item) end

mnuMain = awful.menu({ items = {
	{"terminal",           terminal } ,
	{"tmux",               term_cmd.."tmux" } ,
	{"editor",             editor},
	{"browser",            browser},
	{"file manager",       filemanager},
	{"mpd client",         mpclient},
	{"luakit",             "luakit"},
	{"htop",               term_cmd.."htop"},
	{"weechat",            term_cmd.."weechat-curses"},
	{"rtorrent",           term_cmd.."rtorrent"},
	{"gimp",               "gimp"},
	{"apps",               mnuApps},
	{"composite",          mnuCompositing},
	{"awesome",            mnuAwesome},
}})

mylauncher = awful.widget.launcher({
	image = beautiful.awesome_icon,
	menu = mnuMain
})

menubar.utils.terminal = terminal
-- }}}

-- {{{ Wibox
space = wibox.widget.textbox()
space:set_text(" ")
line = wibox.widget.textbox()
line:set_markup(' <span color="'..theme.bg_focus..'">|</span> ')

datewidget = wibox.widget.textbox()
vicious.register(datewidget, vicious.widgets.date, " %a %F %R ", 60)
datewidget:buttons(awful.util.table.join(
	awful.button({}, 1, function() exec("gsimplecal") end)
))

mpdicon = wibox.widget.imagebox()
mpdicon:set_image(beautifultheme.."icons/music.png")
mpdwidget = wibox.widget.textbox()
vicious.register(mpdwidget, vicious.widgets.mpd, function(widget, args)
	if args["{state}"] == ("Stop" or "N/A") then
		mpdicon.visible = false
		return ""
	else
		mpdicon.visible = true
		if args["{state}"] == "Pause" then
			return ' <span color="'..theme.colors.base0..'">'..args["{Artist}"].." - "..args["{Title}"]..'</span> <span color="'..theme.bg_focus..'">|</span> '
		else
			return " "..args["{Artist}"]..' <span color="'..theme.colors.base0..'">-</span> '..args["{Title}"]..' <span color="'..theme.bg_focus..'">|</span> '
		end
	end
end, 5)
mpdwidget:buttons( awful.util.table.join(
	awful.button({}, 1, function() exec(mpdclient) end),
	awful.button({}, 3, function() sexec("mpc toggle", false) end),
	awful.button({}, 4, function() sexec("mpc prev", false) end),
	awful.button({}, 5, function() sexec("mpc next", false) end)
))

cpuicon = wibox.widget.imagebox()
cpuicon:set_image(beautifultheme.."icons/cpu.png")
cpuwidget = wibox.widget.textbox()
vicious.register(cpuwidget, vicious.widgets.cpu, function(widget, args)
	return string.format("%02d", args[1]).."% " end, .5)

memicon = wibox.widget.imagebox()
memicon:set_image(beautifultheme.."icons/mem.png")
memwidget = wibox.widget.textbox()
vicious.register(memwidget, vicious.widgets.mem,
	'$1% <span color="'..theme.colors.base0..'">(</span>$2<span color="'..theme.colors.base0..'">/$3)</span> ', 5)

baticon = wibox.widget.imagebox()
baticon:set_image(beautifultheme.."icons/bat.png")
batwidget = wibox.widget.textbox()
vicious.register(batwidget, vicious.widgets.bat, "$1$2% ", 30, "BAT1")

tempicon = wibox.widget.imagebox()
tempicon:set_image(beautifultheme.."icons/temp.png")
tempwidget = wibox.widget.textbox()
vicious.register(tempwidget, vicious.widgets.thermal, function(widget, args)
	local temp = tonumber(string.format("%.0f", args[1] * 1.8 + 32))
	if temp > 190 then
		naughty.notify({
		   title = "Temperature Warning",
		   text = "Is it me or is it hot in here?",
		   fg = beautiful.fg_urgent,
		   bg = beautiful.bg_urgent
		})
		temp = '<span color="'..theme.colors.red..'">'..temp..'</span>'
	end
	return temp ..'<span color="'..theme.colors.base0..'">°F</span> '
end, 15, 'thermal_zone0')

wifiicon = wibox.widget.imagebox()
wifiicon:set_image(beautifultheme.."icons/wifi.png")
wifiwidget = wibox.widget.textbox()
vicious.register(wifiwidget, vicious.widgets.wifi, function(widget, args)
	if args["{link}"] == 0 then
		wifiicon.visible = false
		return ""
	else
		wifiicon.visible = true
		return string.format("%i%% ", args["{link}"] / 70 * 100)
	end
end, 4, wirelessinterface)

netdownicon = wibox.widget.imagebox()
netdownicon:set_image(beautifultheme.."icons/down.png")
netdownwidget = wibox.widget.textbox()
vicious.register(netdownwidget, vicious.widgets.net, function(widget, args)
	local i = ""
	if args["{"..wirelessinterface.." carrier}"] == 1 then
		i = wirelessinterface
	elseif args["{"..wiredinterface.." carrier}"] == 1 then
		i = wiredinterface
	else
		netdownicon.visible = false
		return "disconnected"
	end
	netdownicon.visible = true
	return args["{"..i.." down_kb}"]..'k<span color="'..theme.colors.base0..'">/'..args["{"..i.." rx_mb}"].."M</span> "
end, 0.5)

netupicon = wibox.widget.imagebox()
netupicon:set_image(beautifultheme.."icons/up.png")
netupwidget = wibox.widget.textbox()
vicious.register(netupwidget, vicious.widgets.net, function(widget, args)
	local i = ""
	if args["{"..wirelessinterface.." carrier}"] == 1 then
		i = wirelessinterface
	elseif args["{"..wiredinterface.." carrier}"] == 1 then
		i = wiredinterface
	else
		netupicon.visible = false
		return ""
	end
	netdownicon.visible = true
	return args["{"..i.." up_kb}"]..'k<span color="'..theme.colors.base0..'">/'..args["{"..i.." tx_mb}"].."M</span>"
end, 0.5)

mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
	awful.button({}, 1,        awful.tag.viewonly),
	awful.button({modkey}, 1,  awful.client.movetotag),
	awful.button({}, 3,        awful.tag.viewtoggle),
	awful.button({modkey}, 3,  awful.client.toggletag),
	awful.button({}, 4,        function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
	awful.button({}, 5,        function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
)
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
	awful.button({}, 1, function(c)
		if c == client.focus then
			c.minimized = true
		else
			c.minimized = false
			if not c:isvisible() then
				awful.tag.viewonly(c:tags()[1])
			end
			client.focus = c
			c:raise()
		end
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
	end)
)

for s = 1, screen.count() do
	mypromptbox[s] = awful.widget.prompt()
	mylayoutbox[s] = awful.widget.layoutbox(s)
	mylayoutbox[s]:buttons(awful.util.table.join(
		awful.button({}, 1, function() awful.layout.inc(layouts, 1) end),
		awful.button({}, 3, function() awful.layout.inc(layouts, -1) end),
		awful.button({}, 4, function() awful.layout.inc(layouts, 1) end),
		awful.button({}, 5, function() awful.layout.inc(layouts, -1) end))
	)
	mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)
	mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)
	mywibox[s] = {}
	mywibox[s][1] = awful.wibox({position = "top", screen = s, height = 12})
	mywibox[s][2] = awful.wibox({position = "bottom", screen = s, height = 12})
	local layoutA = wibox.layout.align.horizontal()
	local Blayout = wibox.layout.align.horizontal()
	local tplf = wibox.layout.fixed.horizontal()
	local tprt = wibox.layout.fixed.horizontal()
	local bmlf = wibox.layout.fixed.horizontal()
	local bmrt = wibox.layout.fixed.horizontal()
	tplf:add(mylayoutbox[s])
	tplf:add(mytaglist[s])
	tplf:add(mypromptbox[s])
	--tprt:add(mpdicon)
	tprt:add(mpdwidget)
	tprt:add(wifiicon)
	tprt:add(wifiwidget)
	tprt:add(netdownicon)
	tprt:add(netdownwidget)
	tprt:add(netupicon)
	tprt:add(netupwidget)
	tprt:add(line)
	tprt:add(tempicon)
	tprt:add(tempwidget)
	tprt:add(memicon)
	tprt:add(memwidget)
	tprt:add(cpuicon)
	tprt:add(cpuwidget)
	bmlf:add(mylauncher)
	if s == 1 then bmrt:add(wibox.widget.systray()) end
	bmrt:add(datewidget)
	layoutA:set_left(tplf)
	layoutA:set_right(tprt)
	Blayout:set_left(bmlf)
	Blayout:set_middle(mytasklist[s])
	Blayout:set_right(bmrt)
	mywibox[s][1]:set_widget(layoutA)
	mywibox[s][2]:set_widget(Blayout)
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
	awful.key({modkey}, "h",                        awful.tag.viewprev),
	awful.key({modkey}, "l",                        awful.tag.viewnext),
	awful.key({modkey}, "Esc",                      awful.tag.history.restore),
	awful.key({modkey, "Shift"}, "d",               shifty.del),
	awful.key({modkey, "Control"}, "h",             shifty.send_prev),
	awful.key({modkey, "Control"}, "l",             shifty.send_next),
--	awful.key({modkey, "Control"}, "n",             function()
--	                                                	local t = awful.tag.selected()
--	                                                	local s = awful.util.cycle(screen.count(), t.screen + 1)
--	                                                	awful.tag.history.restore()
--	                                                	t = shifty.tagtoscr(s, t)
--	                                                	awful.tag.viewonly(t)
--	                                                end),
	awful.key({modkey}, "a",                        shifty.add),
	awful.key({modkey}, "r",                        shifty.rename),
	awful.key({modkey, "Shift"}, "a",               function() shifty.add({nopopup = true}) end),
	awful.key({modkey}, "j",                        function()
	                                                	awful.client.focus.byidx(1)
	                                                	if client.focus then client.focus:raise() end
	                                                end),
	awful.key({modkey}, "k",                        function()
	                                                	awful.client.focus.byidx(-1)
	                                                	if client.focus then client.focus:raise() end
	                                                end),
	awful.key({modkey}, "w",                        function() mnuMain:toggle({keygrabber = true}) end),
--	awful.key({modkey, "Shift"}, "j",               function() awful.screen.focus(1) end),
--	awful.key({modkey, "Shift"}, "k",               function() awful.screen.focus(-1) end),
	awful.key({modkey}, "u",                        awful.client.urgent.jumpto),
	awful.key({modkey, "Control"}, "r",             awesome.restart),
	awful.key({modkey, "Shift"}, "q",               awesome.quit),
	awful.key({modkey}, "Tab",                      function() awful.menu.clients(nil, {keygrabber = true }) end),
	awful.key({modkey}, "Up",                       function() awful.client.swap.byidx(-1) end),
	awful.key({modkey}, "Down",                     function() awful.client.swap.byidx(1) end),
	awful.key({modkey}, "Left",                     function() awful.tag.incmwfact(-0.05) end),
	awful.key({modkey}, "Right",                    function() awful.tag.incmwfact(0.05) end),
	awful.key({modkey, "Control"}, "Left",          function() awful.tag.incnmaster(1) end),
	awful.key({modkey, "Control"}, "Right",         function() awful.tag.incnmaster(-1) end),
	awful.key({modkey, "Control"}, "Up",            function() awful.tag.incncol(1) end),
	awful.key({modkey, "Control"}, "Down",          function() awful.tag.incncol(-1) end),
	awful.key({modkey}, "space",                    function() awful.layout.inc(layouts, 1) end),
	awful.key({modkey, "Shift"}, "space",           function() awful.layout.inc(layouts, -1) end),
	awful.key({}, "XF86AudioRaiseVolume",           function() sexec("amixer -q set Master 5%+") end),
	awful.key({}, "XF86AudioLowerVolume",           function() sexec("amixer -q set Master 5%-") end),
	awful.key({}, "XF86AudioMute",                  function() sexec("amixer -q set Master toggle") end),
	awful.key({}, "XF86AudioPlay",                  function() sexec("mpc -q toggle", false) end),
	awful.key({}, "XF86AudioStop",                  function() sexec("mpc -q stop", false) end),
	awful.key({}, "XF86AudioNext",                  function() sexec("mpc -q next", false) end),
	awful.key({}, "XF86AudioPrev",                  function() sexec("mpc -q prev", false) end),
	awful.key({modkey}, "F1",                       function()
--	                                                	local f_reader = io.popen( "dmenu_path | dmenu -b -nb '"..beautiful.bg_normal.."' -nf '"..beautiful.fg_normal.."' -sb '"..beautiful.colors.blue.."' -sf '".. beautiful.bg_normal .."'")
	                                                	sexec("dmenu_run -b -hist '"..homedir..".dmenu.history' -fn 'Monaco-8:normal'")
	                                                end),
	awful.key({modkey}, "F2",                       function() exec("gmrun") end),
	awful.key({modkey}, "F3",                       function()
	                                                	awful.prompt.run({ prompt = " Web: " },
	                                                	mypromptbox[mouse.screen].widget,
	                                                	function(command)
	                                                		exec(browser..'"http://yubnub.org/parser/parse?command='..command..'"')
	                                                		awful.tag.viewonly(tags[scount][3])
	                                                	end, nil,
	                                                	awful.util.getdir("cache").."/yubnub_eval")
	                                                end),
	awful.key({modkey}, "F4",                       function()
	                                                	awful.prompt.run({prompt = " Run Lua code: "},
	                                                	mypromptbox[mouse.screen].widget,
	                                                	awful.util.eval, nil,
	                                                	awful.util.getdir("cache").."/history_eval")
	                                                end),
	awful.key({modkey}, "Return",                   function() exec(terminal) end),
	awful.key({modkey, "Mod1" }, "e",               function() exec(editor) end),
	awful.key({modkey, "Mod1" }, "f",               function() exec(filemanager) end),
	awful.key({modkey, "Mod1" }, "h",               function() exec(term_cmd.."htop") end),
	awful.key({modkey, "Mod1" }, "l",               function() exec("xscreensaver-command --lock"); exec("xset dpms force off") end),
	awful.key({modkey, "Mod1" }, "m",               function() exec(mpdclient) end),
	awful.key({modkey, "Mod1" }, "v",               function() exec("pavucontrol") end),
	awful.key({modkey, "Mod1" }, "w",               function() exec(browser) end)
)

clientkeys = awful.util.table.join(
	awful.key({modkey}, "f",                        function(c) c.fullscreen = not c.fullscreen end),
	awful.key({modkey}, "x",                        function(c) c:kill() end),
	awful.key({modkey, "Control"}, "Return",        function(c) c:swap(awful.client.getmaster()) end),
	awful.key({modkey, "Shift"}, "r",               function(c) c:redraw() end),
	awful.key({modkey, "Control"}, "space",         awful.client.floating.toggle),
	awful.key({modkey}, "o",                        awful.client.movetoscreen),
	awful.key({modkey}, "t",                        awful.client.togglemarked),
	awful.key({modkey}, "m",                        function(c)
	                                                	c.maximized_horizontal = not c.maximized_horizontal
	                                                	c.maximized_vertical   = not c.maximized_vertical
	                                                end)
)

clientkeys = awful.util.table.join(
	awful.key({modkey}, "f",                        function(c) c.fullscreen = not c.fullscreen end),
	awful.key({modkey}, "x",                        function(c) c:kill() end),
	awful.key({modkey, "Control"}, "space",         awful.client.floating.toggle),
	awful.key({modkey, "Control"}, "Return",        function(c) c:swap(awful.client.getmaster()) end),
	awful.key({modkey}, "o",                        awful.client.movetoscreen),
	awful.key({modkey}, "t",                        function(c) c.ontop = not c.ontop end),
	awful.key({modkey, "Shift"}, "t",               function(c) shifty.create_titlebar(c) awful.titlebar(c) c.border_width = 1 end),
	awful.key({modkey}, "n",                        function(c) c.minimized = true end),
	awful.key({modkey}, "m",                        function(c)
	                                                	c.maximized_horizontal = not c.maximized_horizontal
	                                                	c.maximized_vertical   = not c.maximized_vertical
	                                                end)
)

shifty.config.clientkeys = clientkeys
shifty.config.modkey = modkey

for i = 1, (shifty.config.maxtags or 9) do
	globalkeys = awful.util.table.join(globalkeys,
		awful.key({modkey}, "#" .. i + 9, function()
			awful.tag.viewonly(shifty.getpos(i))
		end),
		awful.key({modkey, "Control"}, "#" .. i + 9, function()
			awful.tag.viewtoggle(shifty.getpos(i))
		end),
		awful.key({modkey, "Shift"}, "#" .. i + 9, function()
			if client.focus then
				local t = shifty.getpos(i)
				awful.client.movetotag(t)
				awful.tag.viewonly(t)
			end
		end),
		awful.key({modkey, "Control", "Shift"}, "#" .. i + 9, function()
			if client.focus then
				awful.client.toggletag(shifty.getpos(i))
			end
		end)
	)
end

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Signals
client.connect_signal("focus", function(c)
	if not awful.client.ismarked(c) then
		c.border_color = beautiful.border_focus
		c.opacity = 1
	end
end)
client.connect_signal("unfocus", function(c)
	if not awful.client.ismarked(c) then
		c.border_color = beautiful.border_normal
		c.opacity = 0.9
	end
end)

-- }}}
