awful =             require('awful')
awful.autofocus =   require('awful.autofocus')
awful.rules =       require('awful.rules')
awful.remote =      require('awful.remote')
beautiful =         require('beautiful')
naughty =           require('naughty')
vicious =           require('vicious')
shifty =            require('shifty')
freedesktop_utils = require('freedesktop.utils')
freedesktop_menu =  require('freedesktop.menu')

-- {{{ Error handling
if awesome.startup_errors then
	naughty.notify({
		preset = naughty.config.presets.critical,
		title = 'There were errors during startup',
		text = awesome.startup_errors
	})
end

do
	local in_error = false
	awesome.add_signal('debug::error', function(err)
		if in_error then return end
		in_error = true
		naughty.notify({
			preset = naughty.config.presets.critical,
			title = 'An error happened',
			text = err
		})
		in_error = false
	end)
end
-- }}}

-- {{{ Variable definitions
modkey =            'Mod4'
configdir =         awful.util.getdir('config') .. '/'
homedir =           os.getenv('HOME') .. '/'
exec =              awful.util.spawn
sexec =             awful.util.spawn_with_shell
terminal =          'urxvtcd '
term_cmd =          terminal .. '-e '
editor =            term_cmd .. 'vim '
browser =           'firefox '
filemanager =       'x-file-manager '
mpdclient =         'sonata '
--mpdclient =         term_cmd .. 'ncmpcpp'
wirelessinterface = 'wlan0'
wiredinterface =    'eth0'
beautifultheme =    configdir .. 'themes/dfg/'

beautiful.init(beautifultheme .. 'theme.lua')

function run_once(cmd)
	local findme = cmd
	local firstspace = cmd:find(' ')
	if firstspace then
		findme = cmd:sub(0, firstspace - 1)
	end
	sexec('pgrep -x ' .. findme .. ' > /dev/null || (' .. cmd .. ')')
 end

exec    ('nitrogen --restore')
run_once('urxvtd -q -f')
run_once('compton --config ~/.compton.conf')
run_once('mpd')
run_once('thunar --daemon')
run_once('xscreensaver -no-splash')
run_once('xfce4-power-manager')
run_once('sonata --hidden')
run_once('clipit')
run_once('nm-applet')
run_once('pnmixer')
run_once(homedir .. '.dropbox-dist/dropboxd')
-- }}}

-- {{{ Menu
mnuAwesome = {
	{ 'edit configs', editor .. configdir .. 'rc.lua ' .. beautifultheme .. 'theme.lua' },
	{ 'restart', awesome.restart },
	{ 'quit', awesome.quit }
}

mnuCompositing = {
	{ 'stop',  'pkill compton' },
	{ 'start', 'pkill compton && compton' },
}

mnuApps = {}
for _, item in ipairs(freedesktop_menu.new()) do table.insert(mnuApps, item) end

mnuMain = awful.menu({ items = {
	{ 'terminal',           terminal } ,
	{ 'tmux',               term_cmd .. 'tmux' } ,
	{ 'luakit',             'luakit' },
	{ 'editor',             editor },
	{ 'file manager',       filemanager },
	{ 'mpd client',         mpclient },
	{ 'htop',               term_cmd .. 'htop' },
	{ 'apps',               mnuApps },
	{ 'composite',          mnuCompositing },
	{ 'awesome',            mnuAwesome },
}})

mylauncher = awful.widget.launcher({
	image = image(beautiful.awesome_icon),
	menu = mnuMain
})
-- }}}

-- {{{ Shify
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

-- use_titlebar = true

shifty.config.tags = {
	term = {
		layout    = awful.layout.suit.tile.top,
		position  = 1,
		exclusive = true,
		mwfact    = 0.75,
		spawn     = term_cmd .. 'tmux'
	},
	web = {
		layout    = awful.layout.suit.max,
		exclusive = true,
		position  = 2,
		slave     = false,
		spawn     = browser,
	},
	books = {
		layout    = awful.layout.suit.tile,
		spawn     = filemanager .. '/pr0n/books',
		exclusive = false,
	},
	audio = {
		layout    = awful.layout.suit.tile,
		spawn     = mpdclient .. ' && pavucontrol',
		exclusive = false,
	},
}

shifty.config.apps = {
	{
		match = {
			'gmrun',
			'gsimplecal',
			'xfrun4',
			'krunner',
			'pnmixer',
			'.*notify.*'
		},
		slave = false,
		intrusive = true,
		honorsizehints = true,
		skip_taskbar = true,
		float = true,
		sticky = true,
		ontop = true
	},
	{
		match = {
			'Vimperator',
			'Firefox',
			'Iceweasel',
			'chromium',
			'luakit',
			'Nightly',
			'uzbl',
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
			'OpenOffice.*',
			'Abiword',
			'Gnumeric',
		},
		tag = 'office',
	},
	{
		match = {
			'Mirage',
			'qiv',
			'gimp',
			'gtkpod',
			'Ufraw',
			'easytag',
		},
		tag = 'media',
	},
	{
		match = {
			'MPlayer.*',
			'Gnuplot',
			'galculator',
		},
		float = true,
	},
	{
		match = {
			terminal,
			'.*term.*',
			'urxvt.*',
			'konsole',
		},
		tag = 'term',
		slave = true,
	},
	{
		match = {''},
		honorsizehints = false,
		buttons = awful.util.table.join(
			awful.button({ }, 1, function(c) client.focus = c; c:raise() end),
			awful.button({ modkey }, 1, function(c)
				client.focus = c
				c:raise()
				awful.mouse.client.move(c)
			end),
			awful.button({ modkey }, 3, awful.mouse.client.resize)
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

--  {{{ Wibox

--widget:add_signal('mouse::enter', function() return '' end)

datewidget = widget({ type = 'textbox' })
vicious.register(datewidget, vicious.widgets.date, ' %a %b %d %Y  %l:%M:%S ', 1)
datewidget:buttons(awful.util.table.join(
	awful.button({ }, 1, function () exec('gsimplecal') end)
))

mysystray = widget({ type = 'systray', align = 'center' })

mywibox = { }
mypromptbox = { }
mylayoutbox = { }
mytaglist = { }
mytaglist.buttons = awful.util.table.join(
	awful.button({ }, 1,            awful.tag.viewonly),
	awful.button({ modkey }, 1,     awful.client.movetotag),
	awful.button({ }, 3,            function(tag) tag.selected = not tag.selected end),
	awful.button({ modkey }, 3,     awful.client.toggletag),
	awful.button({ }, 4,            awful.tag.viewnext),
	awful.button({ }, 5,            awful.tag.viewprev)
)

mytasklist = { }
mytasklist.buttons = awful.util.table.join(awful.button({ }, 1, function(c)
	if c == client.focus then
		c.minimized = true
	else
		if not c:isvisible() then awful.tag.viewonly(c:tags()[1]) end
		client.focus = c
		c:raise()
	end
end))

space = widget({ type = 'textbox' })
space.text = ' '
spacer = widget({ type = 'textbox' })
spacer.text = ' <span color="' .. theme.bg_focus .. '">⮃</span> '

mpdicon = widget({ type = 'imagebox' })
mpdicon.image = image(beautifultheme .. 'icons/music.png')
mpdwidget = widget({ type = 'textbox' })
vicious.register(mpdwidget, vicious.widgets.mpd, function(widget, args)
	if args['{state}'] == ('Stop' or 'N/A') then
		mpdicon.visible = false
		return ''
	else
		mpdicon.visible = true
		if args['{state}'] == 'Pause' then
			return ' <span color="' .. theme.colors.base0 .. '">' .. args['{Artist}'] .. ' - ' .. args['{Title}'] .. '</span>' .. spacer.text
		else
			return ' ' .. args['{Artist}'] .. '<span color="' .. theme.colors.base0 .. '"> - </span>' .. args['{Title}'] .. spacer.text
		end
	end
end, 5)
mpdwidget:buttons( awful.util.table.join(
	awful.button({ }, 1, function() exec(mpdclient) end),
	awful.button({ }, 3, function() sexec('mpc toggle', false) end),
	awful.button({ }, 4, function() sexec('mpc prev', false) end),
	awful.button({ }, 5, function() sexec('mpc next', false) end)
))

cpuicon = widget({ type = 'imagebox' })
cpuicon.image = image(beautifultheme .. 'icons/cpu.png')
cpuwidget = widget({ type = 'textbox' })
vicious.register(cpuwidget, vicious.widgets.cpu, function(widget, args)
	return string.format('%02d', args[1]) .. '% ' end, .5)

memicon = widget({ type = 'imagebox' })
memicon.image = image(beautifultheme .. 'icons/mem.png')
memwidget = widget({ type = 'textbox' })
vicious.register(memwidget, vicious.widgets.mem,
	'$1% <span color="' .. theme.colors.base0 .. '">(</span>$2<span color="' .. theme.colors.base0 .. '">/$3MB)</span> ', 2.4)

baticon = widget({ type = 'imagebox' })
baticon.image = image(beautifultheme .. 'icons/bat.png')
batwidget = widget({ type = 'textbox' })
vicious.register(batwidget, vicious.widgets.bat, function(widget, args)
	local percent = args[2] .. '%'
	if args[1] == '-' and args[2] < 20 then
		percent = '<span color="' .. theme.colors.red .. '">' .. args[2] .. '% </span>'
	end
	if args[1] == '-' and args[2] < 15 then
		naughty.notify({
			preset = naughty.config.presets.critical,
			title = 'Low power',
			text = "I'm dying! Plug me in!",
			timeout = 15,
		})
	end
	return args[1] .. percent
end, 16.5, 'BAT0')

sensicon = widget({ type = 'imagebox' })
sensicon.image = image(beautifultheme .. 'icons/temp.png')
senswidget = widget({ type = 'textbox' })
vicious.register(senswidget, vicious.widgets.thermal, function(widget, args)
	local temp = tonumber(string.format('%.0f', args[1] * 1.8 + 32))
	if temp > 190 then
		naughty.notify({
			preset = naughty.config.presets.critical,
			title = 'Temperature Warning',
			text = 'Is it me or is it hot in here?',
			timeout = 13,
		})
		temp = '<span color="' .. theme.colors.red .. '">' .. temp .. '</span>'
	end
	return temp  .. '<span color="' .. theme.colors.base0 .. '">°F</span> '
end, 14, 'thermal_zone0')

wifiicon = widget({ type = 'imagebox' })
wifiicon.image = image(beautifultheme .. 'icons/wifi.png')
wifiwidget = widget({ type = 'textbox' })
vicious.register(wifiwidget, vicious.widgets.wifi, function(widget, args)
	if args['{link}'] == 0 then
		wifiicon.visible = false
		return ''
	else
		wifiicon.visible = true
		return string.format('%i%% ', args['{link}'] / 70 * 100)
	end
end, 4.5, wirelessinterface)

netdownicon = widget({ type = 'imagebox' })
netdownicon.image = image(beautifultheme .. 'icons/down.png')
netdownwidget = widget({ type = 'textbox' })
vicious.register(netdownwidget, vicious.widgets.net, function(widget, args)
	local i = ''
	if args['{' .. wirelessinterface .. ' carrier}'] == 1 then
		i = wirelessinterface
	elseif args['{' .. wiredinterface .. ' carrier}'] == 1 then
		i = wiredinterface
	else
		netdownicon.visible = false
		return 'disconnected'
	end
	netdownicon.visible = true
	return args['{' .. i .. ' down_kb}'] .. 'k<span color="' .. theme.colors.base0 .. '">/' .. string.format('%.0f', args['{' .. i .. ' rx_mb}']) .. 'M</span> '
end, 1.5)

netupicon = widget({ type = 'imagebox' })
netupicon.image = image(beautifultheme .. 'icons/up.png')
netupwidget = widget({ type = 'textbox' })
vicious.register(netupwidget, vicious.widgets.net, function(widget, args)
	local i = ''
	if args['{' .. wirelessinterface .. ' carrier}'] == 1 then
		i = wirelessinterface
	elseif args['{' .. wiredinterface .. ' carrier}'] == 1 then
		i = wiredinterface
	else
		netupicon.visible = false
		return ''
	end
	netupicon.visible = true
	return args['{' .. i .. ' up_kb}'] .. 'k<span color="' .. theme.colors.base0 .. '">/' .. string.format('%.0f', args['{' .. i .. ' tx_mb}']) .. 'M</span>'
end, 1.5)

mailicon = widget({ type = 'imagebox' })
mailicon.image = image(beautifultheme .. 'icons/mail.png')
mailwidget = widget({ type = 'textbox' })
vicious.register(mailwidget, vicious.widgets.gmail, function(widget, args)
	if args['{count}'] > 0 then
		mailicon.visible = true
		return args['{count}'] .. ' '
	else
		mailicon.visible = false
		return ''
	end
end, 10)


 for s = 1, screen.count() do
 	mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
 	mylayoutbox[s] = awful.widget.layoutbox(s)
 	mylayoutbox[s]:buttons(awful.util.table.join(
 		awful.button({ }, 1, function() awful.layout.inc(layouts, 1) end),
 		awful.button({ }, 3, function() awful.layout.inc(layouts, -1) end),
 		awful.button({ }, 4, function() awful.layout.inc(layouts, 1) end),
 		awful.button({ }, 5, function() awful.layout.inc(layouts, -1) end)))
 	mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)
 	mytasklist[s] = awful.widget.tasklist(function(c)
		return awful.widget.tasklist.label.currenttags(c, s)
	end, mytasklist.buttons)
	mywibox[s] = { }
	mywibox[s][1] = awful.wibox({ position = 'top', screen = s, height = 12 })
	mywibox[s][2] = awful.wibox({ position = 'bottom', screen = s, height = 12 })
	mywibox[s][1].widgets = {
		mylayoutbox[s],
		mytaglist[s],
		mypromptbox[s], {
			cpuwidget, cpuicon,
			memwidget, memicon,
			spacer,
			batwidget, baticon,
			senswidget, sensicon,
			spacer,
			netupwidget, netupicon,
			netdownwidget, netdownicon,
			wifiwidget, wifiicon,
			mailwidget, mailicon,
			mpdwidget, mpdicon,
			spacer,
			layout = awful.widget.layout.horizontal.rightleft
		},
		layout = awful.widget.layout.horizontal.leftright
	}
	mywibox[s][2].widgets = {
		datewidget,
		s == 1 and mysystray or nil, {
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

-- {{{ Key bindings
globalkeys = awful.util.table.join(
	awful.key({ modkey }, 'h',                      awful.tag.viewprev),
	awful.key({ modkey }, 'l',                      awful.tag.viewnext),
	awful.key({ modkey }, 'Esc',                    awful.tag.history.restore),
	awful.key({ modkey, 'Shift' }, 'd',             shifty.del),
	awful.key({ modkey, 'Control' }, 'h',           shifty.send_prev),
	awful.key({ modkey, 'Control' }, 'l',           shifty.send_next),
	awful.key({ modkey, 'Control' }, 'n',           function()
	                                                	local t = awful.tag.selected()
	                                                	local s = awful.util.cycle(screen.count(), t.screen + 1)
	                                                	awful.tag.history.restore()
	                                                	t = shifty.tagtoscr(s, t)
	                                                	awful.tag.viewonly(t)
	                                                end),
	awful.key({ modkey }, 'a',                      shifty.add),
	awful.key({ modkey }, 'r',                      shifty.rename),
	awful.key({ modkey, 'Shift'}, 'a',              function() shifty.add({ nopopup = true }) end),
	awful.key({ modkey }, 'j',                      function()
	                                                	awful.client.focus.byidx(1)
	                                                	if client.focus then client.focus:raise() end
	                                                end),
	awful.key({ modkey }, 'k',                      function()
	                                                	awful.client.focus.byidx(-1)
	                                                	if client.focus then client.focus:raise() end
	                                                end),
	awful.key({ modkey }, 'w',                      function() mnuMain:toggle({ keygrabber = true}) end),
	awful.key({ modkey, 'Shift' }, 'h',             function() shifty.tagtoscr(awful.util.cycle(screen.count(), mouse.screen + 1)) end),
	awful.key({ modkey, 'Shift' }, 'l',             function() shifty.tagtoscr(awful.util.cycle(screen.count(), mouse.screen - 1)) end),
	awful.key({ modkey, 'Shift' }, 'Left',          function() awful.screen.focus_relative(1) end),
	awful.key({ modkey, 'Shift' }, 'Right',         function() awful.screen.focus_relative(-1) end),
	awful.key({ modkey }, 'u',                      awful.client.urgent.jumpto),
	awful.key({ modkey, 'Control' }, 'r',           awesome.restart),
	awful.key({ modkey, 'Shift' }, 'q',             awesome.quit),
	awful.key({ modkey }, 'Tab',                    function() awful.menu.clients(nil, { keygrabber = true }) end),
	awful.key({ modkey }, 'Up',                     function()
	                                                	-- awful.client.cycle(true)
	                                                	awful.client.focus.byidx(-1)
	                                                	if client.focus then client.focus:raise() end
	                                                	awful.client.swap.byidx(1)
	                                                end),
	awful.key({ modkey }, 'Down',                   function()
	                                                	-- awful.client.cycle(false)
	                                                	awful.client.focus.byidx(1)
	                                                	if client.focus then client.focus:raise() end
	                                                	awful.client.swap.byidx(-1)
	                                                end),
	awful.key({ modkey, 'Shift' }, 'Up',            function() awful.client.swap.byidx(-1) end),
	awful.key({ modkey, 'Shift' }, 'Down',          function() awful.client.swap.byidx(1) end),
	awful.key({ modkey }, 'Left',                   function() awful.tag.incmwfact(-0.05) end),
	awful.key({ modkey }, 'Right',                  function() awful.tag.incmwfact(0.05) end),
	awful.key({ modkey, 'Control' }, 'Left',        function() awful.tag.incnmaster(1) end),
	awful.key({ modkey, 'Control' }, 'Right',       function() awful.tag.incnmaster(-1) end),
	awful.key({ modkey, 'Control' }, 'Up',          function() awful.tag.incncol(1) end),
	awful.key({ modkey, 'Control' }, 'Down',        function() awful.tag.incncol(-1) end),
	awful.key({ modkey }, 'space',                  function() awful.layout.inc(layouts, 1) end),
	awful.key({ modkey, 'Shift' }, 'space',         function() awful.layout.inc(layouts, -1) end),
	awful.key({ }, 'XF86AudioRaiseVolume',          function() sexec('amixer -q set Master 5%+') end),
	awful.key({ }, 'XF86AudioLowerVolume',          function() sexec('amixer -q set Master 5%-') end),
	awful.key({ }, 'XF86AudioMute',                 function() sexec('amixer -q set Master toggle') end),
	awful.key({ }, 'XF86AudioPlay',                 function() sexec('mpc -q toggle', false) end),
	awful.key({ }, 'XF86AudioStop',                 function() sexec('mpc -q stop', false) end),
	awful.key({ }, 'XF86AudioNext',                 function() sexec('mpc -q next', false) end),
	awful.key({ }, 'XF86AudioPrev',                 function() sexec('mpc -q prev', false) end),
	awful.key({ modkey }, 'F1',                     function()
	                                                	--local f_reader = io.popen( 'dmenu_path | dmenu -b -nb "' .. beautiful.bg_normal .. '" -nf "' .. beautiful.fg_normal .. '" -sb "' .. beautiful.colors.blue .. '" -sf "' ..  beautiful.bg_normal  .. '"')
	                                                	sexec('dmenu_run -b -nb "' .. beautiful.bg_normal .. '" -nf "' .. beautiful.fg_normal .. '" -sb "' .. beautiful.colors.blue .. '" -sf "' ..  beautiful.bg_normal  .. '"')
	                                                end),
	awful.key({ modkey }, 'F2',                     function() exec('gmrun') end),
	--awful.key({ modkey, 'Mod1' }, 'F2',             function() exec('spring') end)
	awful.key({ modkey }, 'F3',                     function()
	                                                	awful.prompt.run({ prompt = ' Web: ' },
	                                                	mypromptbox[mouse.screen].widget,
	                                                	function(command)
	                                                		exec(browser .. '"http://yubnub.org/parser/parse?command=' .. command .. '"')
	                                                		awful.tag.viewonly(tags[scount][3])
	                                                	end, nil,
	                                                	awful.util.getdir('cache') .. '/yubnub_eval')
	                                                end),
	awful.key({ modkey }, 'F4',                     function()
	                                                	awful.prompt.run({ prompt = ' Run Lua code: ' },
	                                                	mypromptbox[mouse.screen].widget,
	                                                	awful.util.eval, nil,
	                                                	awful.util.getdir('cache') .. '/history_eval')
	                                                end),
	awful.key({ modkey }, 'Return',                 function() exec(terminal) end),
	awful.key({ modkey, 'Mod1' }, 'e',              function() exec(editor) end),
	awful.key({ modkey, 'Mod1' }, 'f',              function() exec(filemanager) end),
	awful.key({ modkey, 'Mod1' }, 'h',              function() exec(term_cmd .. 'htop') end),
	awful.key({ modkey, 'Mod1' }, 'l',              function() exec('screenlock') end),
	awful.key({ modkey, 'Mod1', 'Shift' }, 'l',     function() exec('screenlock --suspend') end),
	awful.key({ modkey, 'Mod1' }, 'm',              function() exec(mpdclient) end),
	awful.key({ modkey, 'Mod1' }, 'v',              function() exec('pavucontrol') end),
	awful.key({ modkey, 'Mod1' }, 'w',              function() exec(browser) end),
	awful.key({ modkey, 'Mod1' }, 't',              function() sexec("synclient TouchpadOff=$(synclient -l | grep -c 'TouchpadOff.*=.*0')") end)
)

clientkeys = awful.util.table.join(
	awful.key({ modkey }, 'f',                      function(c) c.fullscreen = not c.fullscreen end),
	awful.key({ modkey }, 'x',                      function(c) c:kill() end),
	awful.key({ modkey, 'Control' }, 'Return',      function(c) c:swap(awful.client.getmaster()) end),
	awful.key({ modkey, 'Shift' }, 'r',             function(c) c:redraw() end),
	awful.key({ modkey, 'Control' }, 'space',       awful.client.floating.toggle),
	awful.key({ modkey }, 'o',                      awful.client.movetoscreen),
	awful.key({ modkey }, 't',                      awful.client.togglemarked),
	awful.key({ modkey }, 'm',                      function(c)
	                                                	c.maximized_horizontal = not c.maximized_horizontal
	                                                	c.maximized_vertical   = not c.maximized_vertical
	                                                end)
)

for i = 1, (shifty.config.maxtags or 9) do
	globalkeys = awful.util.table.join(globalkeys,
		awful.key({ modkey }, i, function()
			local t = awful.tag.viewonly(shifty.getpos(i))
		end),
		awful.key({ modkey, 'Control' }, i, function()
			local t = shifty.getpos(i)
			t.selected = not t.selected
		end),
		awful.key({ modkey, 'Control', 'Shift' }, i, function()
			if client.focus then
				awful.client.toggletag(shifty.getpos(i))
			end
		end),
		awful.key({ modkey, 'Shift' }, i, function()
			if client.focus then
				t = shifty.getpos(i)
				awful.client.movetotag(t)
				awful.tag.viewonly(t)
			end
		end))
	end

root.keys(globalkeys)
shifty.config.clientkeys = clientkeys
shifty.config.modkey = modkey
--}}}

-- {{{ Signals
client.add_signal('focus', function(c)
	if not awful.client.ismarked(c) then
		c.border_color = beautiful.border_focus
		c.opacity = 1
	end
end)

client.add_signal('unfocus', function(c)
	if not awful.client.ismarked(c) then
		c.border_color = beautiful.border_normal
		c.opacity = 0.9
	end
end)

client.add_signal('manage', function (c, startup)
--	if awful.client.floating.get(c)
--	or awful.layout.get(c.screen) == awful.layout.suit.floating then
--		if c.titlebar then awful.titlebar.remove(c)
--		else awful.titlebar.add(c, {modkey = modkey, height = '12', position = 'bottom'}) end
--	end
	c:add_signal('mouse::enter', function (c)
		if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier and awful.client.focus.filter(c) then
			client.focus = c
		end
	end)
	if not startup then
		awful.client.setslave(c)
		if not c.size_hints.program_position and not c.size_hints.user_position then
			awful.placement.no_overlap(c)
			awful.placement.no_offscreen(c)
		end
	end
end)
--}}}
