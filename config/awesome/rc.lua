local awful             = require("awful")
awful.autofocus         = require("awful.autofocus")
awful.rules             = require("awful.rules")
local wibox             = require("wibox")
local beautiful         = require("beautiful")
local naughty           = require("naughty")
local menubar           = require("menubar")
local shifty            = require("shifty")
local lain              = require("lain")
local freedesktop_utils = require("freedesktop.utils")
local freedesktop_menu  = require("freedesktop.menu")

-- {{{ Error handling
if awesome.startup_errors then
  naughty.notify({
    preset = naughty.config.presets.critical,
    title = "There were errors during startup",
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
      title = "An error happened",
      text = err
    })
    in_error = false
  end)
end
-- }}}

-- {{{ Layouts
local layouts = {
  awful.layout.suit.floating,
  lain.layout.uselesstile,
  lain.layout.centerwork,
  lain.layout.uselessfair,
  awful.layout.suit.max
}
-- }}}

-- {{{ Variables
modkey         = "Mod4"
exec           = awful.util.spawn
sexec          = awful.util.spawn_with_shell
configdir      = awful.util.getdir("config") .. "/"
homedir        = os.getenv("HOME") .. "/"
beautifultheme = configdir .. "themes/dfg/"
terminal       = "x-terminal-emulator"
browser        = "x-www-browser"
filemanager    = "x-file-manager"
mpdclient      = "sonata --visible"
editor         = os.getenv("EDITOR") or "vim" or "nano"
editor_cmd     = terminal .. " -e " .. editor

beautiful.init(beautifultheme .. "theme.lua")

function run_once(cmd)
  local findme = cmd
  local firstspace = cmd:find(" ")
  if firstspace then
    findme = cmd:sub(0, firstspace - 1)
  end
  sexec("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end

exec("nitrogen --restore")
run_once("urxvtd -q -f")
run_once("compton --config ~/.compton.conf")
run_once("mpd")
run_once("keepassx")
run_once("clipit")
run_once("nm-applet")
run_once("pnmixer")
run_once("xfce4-power-manager")
run_once(mpdclient)
run_once("redshift-gtk lat=29.27 lon=-94.87")

shifty.config.tags = {
  term = {
    layout    = lain.layout.uselesstile,
    position  = 1,
    exclusive = true,
    mwfact    = 0.5,
  },
  web = {
    layout    = lain.layout.uselessfair,
    exclusive = true,
    position  = 2,
    slave     = false,
    spawn     = browser,
  },
  audio = {
    layout    = lain.layout.uselesstile,
    position  = 3,
    exclusive = false,
    spawn     = "pavucontrol"
  },
}

shifty.config.apps = {
  {
    match = {
      "gmrun",
      "gsimplecal",
      "xfrun4",
      "krunner",
      "pnmixer",
      ".*notify.*"
    },
    slave = false,
    intrusive = true,
    honorsizehints = true,
    skip_taskbar = true,
    float = true,
    sticky = true,
    ontop = true
  }, {
    match = {
      "Firefox",
      "Iceweasel",
      "Vimperator",
      "Pentadactyl",
      "chromium",
      "google.chrome.*",
      "luakit",
      "Nightly",
      "uzbl",
    },
    tag = "web",
  }, {
    match = {
      "Shredder.*",
      "Thunderbird",
      "mutt",
    },
    tag = "mail",
  }, {
    match = {
      "OpenOffice.*",
      "Abiword",
      "Gnumeric",
    },
    tag = "office",
  }, {
    match = {
      "Mirage",
      "qiv",
      "gimp",
      "gtkpod",
      "Ufraw",
      "easytag",
    },
    tag = "media",
  }, {
    match = {
      "MPlayer.*",
      "mpv.*",
      "popcorn-time",
      "Gnuplot",
      "galculator",
    },
    tag = "media",
    float = true,
  }, {
    match = {
      mpdclient,
      "pavucontrol",
      "sonata",
      "gmpc",
      "ncmpcpp",
      "audacity",
      "mixxx",
      "guitarpro",
    },
    tag = "audio",
    slave = true,
  }, {
    match = {
      terminal,
      ".*term.*",
      "urxvt.*",
      "xterm",
      "konsole",
    },
    tag = "term",
    slave = true,
  }, {
    match = { "" },
    honorsizehints = false,
    buttons = awful.util.table.join(
      awful.button({ }, 1, function(c)
        client.focus = c
        c:raise()
      end),
      awful.button({ modkey }, 1, function(c)
        client.focus = c
        c:raise()
        awful.mouse.client.move(c)
      end),
      awful.button({ modkey }, 3, awful.mouse.client.resize)
    )
  }
}

shifty.config.defaults = {
  layout = awful.layout.suit.floating,
  ncol = 1,
  mwfact = 0.50,
  floatBars = true,
  guess_name = true,
  guess_position = true,
}

-- }}}

-- {{{ Wibox widgets
menu_items = freedesktop.menu.new()
mymainmenu = awful.menu.new({ items = menu_items, width = 150 })
mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon, menu = mymainmenu })
freedesktop.utils.icon_theme = 'oxygen'

markup = lain.util.markup
spr = wibox.widget.textbox(" ")
lsep = wibox.widget.textbox(markup("#666", " "))

clockicon = wibox.widget.background(wibox.widget.imagebox(beautiful.widget_clock))
mytextclock = wibox.widget.background(awful.widget.textclock(" %a %d %b %r ", 1))

lain.widgets.calendar:attach(mytextclock)

mpdicon = wibox.widget.imagebox(beautiful.widget_music)
mpdwidget = lain.widgets.mpd({
  settings = function()
    if mpd_now.state == "play" then
      artist = " " .. mpd_now.artist .. " - "
      title = mpd_now.title .. " "
      mpdicon:set_image(beautiful.widget_music_on)
    elseif mpd_now.state == "pause" then
      artist = markup("#666", " " .. mpd_now.artist .. " - ")
      title = markup("#666", mpd_now.title .. " ")
    else
      artist = ""
      title = ""
      mpdicon:set_image(beautiful.widget_music)
    end
    widget:set_markup(artist .. title)
  end
})

mpdwidget:buttons(awful.util.table.join(
  awful.button({ }, 3, function()
    sexec("mpc -q toggle")
    mpdwidget.update()
  end),
  awful.button({ }, 1, function()
    sexec(mpdclient)
  end)
))
mpdwidgetbg = wibox.widget.background(mpdwidget)

memicon = wibox.widget.background(wibox.widget.imagebox(beautiful.widget_mem))
memwidget = wibox.widget.background(lain.widgets.mem({
  settings = function()
    widget:set_markup(" " .. mem_now.used .. markup("#666", "MB "))
  end
}))

cpuicon = wibox.widget.background(wibox.widget.imagebox(beautiful.widget_cpu))
cpuwidget = wibox.widget.background(lain.widgets.cpu({
  settings = function()
    widget:set_markup(" " .. string.format("%02d", cpu_now.usage) .. markup("#666", "% "))
  end
}))

tempicon = wibox.widget.background(wibox.widget.imagebox(beautiful.widget_temp))
tempwidget = wibox.widget.background(lain.widgets.temp({
  settings = function()
    widget:set_markup(" " .. coretemp_now .. markup("#666", "°C "))
  end
}))

fsicon = wibox.widget.background(wibox.widget.imagebox(beautiful.widget_hdd))
fswidget = wibox.widget.background(lain.widgets.fs({
  settings = function()
    widget:set_markup(" " .. fs_now.used .. markup("#666", "% "))
  end
}))
fswidgetbg = wibox.widget.background(fswidget)

-- baticon = wibox.widget.imagebox(beautiful.widget_battery)
-- batticon = wibox.widget.background((baticon))
-- batwidget = lain.widgets.bat({
--   settings = function()
--     if bat_now.perc == "N/A" then
--       widget:set_markup(" AC ")
--       baticon:set_image(beautiful.widget_ac)
--       return
--     elseif tonumber(bat_now.perc) <= 5 then
--       baticon:set_image(beautiful.widget_battery_empty)
--     elseif tonumber(bat_now.perc) <= 15 then
--       baticon:set_image(beautiful.widget_battery_low)
--     else
--       baticon:set_image(beautiful.widget_battery)
--     end
--     widget:set_markup(" " .. bat_now.perc .. "% ")
--   end
-- })
-- battwidget = wibox.widget.background(batwidget)

netupicon = wibox.widget.background(wibox.widget.imagebox(beautiful.widget_netup))
netupwidget = wibox.widget.background(lain.widgets.net({
  settings = function()
    widget:set_markup(net_now.sent .. "K ")
  end
}))

netdownicon = wibox.widget.background(wibox.widget.imagebox(beautiful.widget_netdown))
netdownwidget = wibox.widget.background(lain.widgets.net({
  settings = function()
    widget:set_markup(net_now.received .. "K ")
  end
}))
-- }}}

-- {{{ Wibox controls
mywibox = {}
lowerwibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytasklist = {}

mytaglist.buttons = awful.util.table.join(
  awful.button({ modkey }, 1, awful.client.movetotag),
  awful.button({ modkey }, 3, awful.client.toggletag),
  awful.button({ }, 1, awful.tag.viewonly),
  awful.button({ }, 3, awful.tag.viewtoggle),
  awful.button({ }, 4, function(t)
    awful.tag.viewnext(awful.tag.getscreen(t))
  end),
  awful.button({ }, 5, function(t)
    awful.tag.viewprev(awful.tag.getscreen(t))
  end)
)

mytasklist.buttons = awful.util.table.join(
  awful.button({ }, 1, function(c)
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
  awful.button({ }, 3, function()
    if instance then
      instance:hide()
      instance = nil
    else
      instance = awful.menu.clients({ width=250 })
    end
  end),
  awful.button({ }, 4, function()
    awful.client.focus.byidx(1)
    if client.focus then client.focus:raise() end
  end),
  awful.button({ }, 5, function()
    awful.client.focus.byidx(-1)
    if client.focus then client.focus:raise() end
  end)
)

for s = 1, screen.count() do
  mypromptbox[s] = awful.widget.prompt()
  mylayoutbox[s] = awful.widget.layoutbox(s)
  mylayoutbox[s]:buttons(awful.util.table.join(
    awful.button({ }, 1, function()
      awful.layout.inc(layouts, 1)
    end),
    awful.button({ }, 3, function()
      awful.layout.inc(layouts, -1)
    end),
    awful.button({ }, 4, function()
      awful.layout.inc(layouts, 1)
    end),
    awful.button({ }, 5, function()
      awful.layout.inc(layouts, -1)
    end)
  ))

  mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)
  mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)
  mywibox[s] = awful.wibox({ position = "top", screen = s, height = beautiful.awful_widget_height })

  local left_layout = wibox.layout.fixed.horizontal()
  left_layout:add(mytaglist[s])
  left_layout:add(mylayoutbox[s])
  left_layout:add(mypromptbox[s])
  left_layout:add(spr)

  local right_layout = wibox.layout.fixed.horizontal()
  right_layout:add(spr)
  right_layout:add(mpdwidget)
  right_layout:add(lsep)
  right_layout:add(netdownicon)
  right_layout:add(netdownwidget)
  right_layout:add(netupicon)
  right_layout:add(netupwidget)
  -- right_layout:add(lsep)
  -- right_layout:add(batticon)
  -- right_layout:add(battwidget)
  right_layout:add(lsep)
  right_layout:add(tempicon)
  right_layout:add(tempwidget)
  right_layout:add(lsep)
  right_layout:add(fsicon)
  right_layout:add(fswidgetbg)
  right_layout:add(lsep)
  right_layout:add(memicon)
  right_layout:add(memwidget)
  right_layout:add(cpuicon)
  right_layout:add(cpuwidget)

  local layout = wibox.layout.align.horizontal()
  layout:set_left(left_layout)
  -- layout:set_middle(mytasklist[s])
  layout:set_right(right_layout)
  mywibox[s]:set_widget(layout)

  lowerwibox[s] = awful.wibox({ position = "bottom", screen = s, height = beautiful.awful_widget_height })

  local lower_left_layout = wibox.layout.fixed.horizontal()
  lower_left_layout:add(mylauncher)

  local lower_right_layout = wibox.layout.fixed.horizontal()
  if s == 1 then
    lower_right_layout:add(lsep)
    lower_right_layout:add(wibox.widget.systray())
    lower_right_layout:add(spr)
  end
  lower_right_layout:add(lsep)
  lower_right_layout:add(clockicon)
  lower_right_layout:add(mytextclock)

  lower_layout = wibox.layout.align.horizontal()
  lower_layout:set_left(lower_left_layout)
  lower_layout:set_middle(mytasklist[s])
  lower_layout:set_right(lower_right_layout)
  lowerwibox[s]:set_widget(lower_layout)
end

shifty.taglist = mytaglist
shifty.init()
-- }}}

-- {{{ Keybinds
root.buttons(awful.util.table.join(
  awful.button({ modkey }, 2, awful.client.floating.toggle),
  awful.button({ }, 4, awful.tag.viewnext),
  awful.button({ }, 5, awful.tag.viewprev)
))

globalkeys = awful.util.table.join(
  awful.key({ modkey }, "Left", awful.tag.viewprev),
  awful.key({ modkey }, "Right", awful.tag.viewnext),
  awful.key({ modkey }, "Escape", awful.tag.history.restore),
  awful.key({ modkey }, "j", function()
    awful.client.focus.bydirection("down")
    if client.focus then client.focus:raise() end
  end),
  awful.key({ modkey }, "k", function()
    awful.client.focus.bydirection("up")
    if client.focus then client.focus:raise() end
  end),
  awful.key({ modkey }, "h", function()
    awful.client.focus.bydirection("left")
    if client.focus then client.focus:raise() end
  end),
  awful.key({ modkey }, "l", function()
    awful.client.focus.bydirection("right")
    if client.focus then client.focus:raise() end
  end),
  awful.key({ modkey }, "b", function()
    mywibox[mouse.screen].visible = not mywibox[mouse.screen].visible
  end),
  awful.key({ modkey, "Control" }, "=", function()
    lain.util.useless_gaps_resize(1)
    lain.util.global_border_resize(1)
  end),
  awful.key({ modkey, "Control" }, "-", function()
    lain.util.useless_gaps_resize(-1)
    lain.util.global_border_resize(-1)
  end),
  awful.key({ modkey, "Shift" }, "j", function()
    awful.client.swap.byidx(1)
  end),
  awful.key({ modkey, "Shift" }, "k", function()
    awful.client.swap.byidx(-1)
  end),
  awful.key({ modkey, "Control" }, "j", function()
    awful.screen.focus_relative(1)
  end),
  awful.key({ modkey, "Control" }, "k", function()
    awful.screen.focus_relative(-1)
  end),
  awful.key({ modkey }, "u", awful.client.urgent.jumpto),
  awful.key({ modkey }, "Tab", function()
    awful.client.focus.history.previous()
    if client.focus then
      client.focus:raise()
    end
  end),
  awful.key({ modkey, "Shift" }, "h", function()
    awful.tag.incmwfact(-0.05)
  end),
  awful.key({ modkey, "Shift" }, "l", function()
    awful.tag.incmwfact(0.05)
  end),
  awful.key({ modkey, "Control" }, "h", function()
    awful.tag.incnmaster(1)
  end),
  awful.key({ modkey, "Control" }, "l", function()
    awful.tag.incnmaster(-1)
  end),
  awful.key({ modkey, "Control" }, "j", function()
    awful.tag.incncol(-1)
  end),
  awful.key({ modkey, "Control" }, "k", function()
    awful.tag.incncol(1)
  end),
  awful.key({ modkey }, "space", function()
    awful.layout.inc(layouts, 1)
  end),
  awful.key({ modkey, "Shift" }, "space", function()
    awful.layout.inc(layouts, -1)
  end),
  awful.key({ modkey, "Control" }, "n", awful.client.restore),
  awful.key({ modkey, "Control" }, "r", awesome.restart),
  awful.key({ modkey, "Shift" }, "q", awesome.quit),
  -- awful.key({ modkey }, "r", function()
  --   mypromptbox[mouse.screen]:run()
  -- end),
  awful.key({ modkey }, "F4", function()
    awful.prompt.run({ prompt = "Run Lua code: " },
    mypromptbox[mouse.screen].widget,
    awful.util.eval, nil,
    awful.util.getdir("cache") .. "/history_eval")
  end),
  -- awful.key({ }, "XF86AudioRaiseVolume", function()
  --   exec("amixer -q sset Master 1%+")
  -- end),
  -- awful.key({ }, "XF86AudioLowerVolume", function()
  --   exec("amixer -q sset Master 1%-")
  -- end),
  -- awful.key({ }, "XF86AudioMute", function()
  --   exec("amixer -q sset Master toggle")
  -- end),
  awful.key({ modkey, "Shift" }, "d", function()
    lain.util.remove_tag()
  end),
  awful.key({ modkey, "Shift" }, "Left", function()
    lain.util.move_tag(-1)
  end),
  awful.key({ modkey, "Shift" }, "Right", function()
    lain.util.move_tag(1)
  end),
  awful.key({ modkey }, "Return", function()
    exec(terminal)
  end),
  awful.key({ modkey }, "o", function(c)
    awful.client.cycle(true, s)
    awful.client.jumpto(awful.client.getmaster())
  end),
  awful.key({ modkey, "Shift" }, "o", function(c)
    awful.client.cycle(false, s)
    awful.client.jumpto(awful.client.getmaster())
  end),
  awful.key({ modkey }, "x", function(c)
    keygrabber.run(function(mod, key, event)
      if event == "release" then
        return true
      end
      keygrabber.stop()
      if modal_exec[key] then
        modal_exec[key](c)
      end
      return true
    end)
  end),
  awful.key({ modkey }, "r", function()
    menubar.show()
  end),
  awful.key({ modkey, "Shift" }, "d", shifty.del),
  awful.key({ modkey, "Shift" }, "n", shifty.send_prev),
  awful.key({ modkey }, "n", shifty.send_next),
  awful.key({ modkey, "Control" }, "n", function()
    local t = awful.tag.selected()
    local s = awful.util.cycle(screen.count(), awful.tag.getscreen(t) + 1)
    awful.tag.history.restore()
    t = shifty.tagtoscr(s, t)
    awful.tag.viewonly(t)
  end),
  awful.key({ modkey }, "a", shifty.add),
  awful.key({ modkey, "Shift" }, "r", shifty.rename),
  awful.key({ modkey, "Shift" }, "a", function()
    shifty.add({ nopopup = true })
  end)
)

modal_exec = {
  m = function()
    keygrabber.run(function(mod, key, event)
      if event == "release" then
        return true
      end
      keygrabber.stop()
      if modal_music[key] then
        modal_music[key](c)
      end
      return true
    end)
  end,
  w = function()
    exec(browser)
  end,
  f = function()
    exec(filemanager)
  end,
  v = function()
    exec("pavucontrol")
  end
}

modal_music = {
  t = function()
    sexec("mpc -q toggle")
    mpdwidget.update()
  end,
  n = function()
    sexec("mpc -q next")
    mpdwidget.update()
  end,
  s = function()
    sexec("mpc -q stop")
    mpdwidget.update()
  end,
  p = function()
    sexec("mpc -q prev")
    mpdwidget.update()
  end,
  f = function()
    exec(terminal .. " -e fzmp")
    mpdwidget.update()
  end,
}

client_keys = {
  c = function(c)
    c:kill()
  end,
  d = function(c)
    c:redraw()
  end,
  f = function(c)
    keygrabber.run(function(mod, key, event)
      if event == "release" then
        return true
      end
      keygrabber.stop()
      if key == "u" then
        c.fullscreen = not c.fullscreen
      elseif key == "l" then
        awful.client.floating.toggle(c)
      end
      return true
    end)
  end,
  m = function(c)
    c.maximized_horizontal = not c.maximized_horizontal
    c.maximized_vertical = not c.maximized_vertical
    c:raise()
  end,
  n = function(c)
    c.minimized = true
  end,
  o = function(c)
    c.ontop = not c.ontop
  end,
  t = awful.client.togglemarked
}

clientkeys = awful.util.table.join(
  awful.key({ modkey, "Control" }, "Return", function(c)
    c:swap(awful.client.getmaster())
  end),
  awful.key({ modkey, "Mod1" }, "o", awful.client.movetoscreen),
  awful.key({ modkey }, "c", function(c)
    keygrabber.run(function(mod, key, event)
      if event == "release" then
        return true
      end
      keygrabber.stop()
      if client_keys[key] then
        client_keys[key](c)
      end
      return true
    end)
  end)
)

shifty.config.clientkeys = clientkeys
shifty.config.modkey = modkey

for i = 1,(shifty.config.maxtags or 9) do
  globalkeys = awful.util.table.join(globalkeys,
  awful.key({ modkey }, "#" .. i + 9, function()
    awful.tag.viewonly(shifty.getpos(i))
  end),
  awful.key({ modkey, "Control" }, "#" .. i + 9, function()
    awful.tag.viewtoggle(shifty.getpos(i))
  end),
  awful.key({ modkey, "Shift" }, "#" .. i + 9, function()
    if client.focus then
      local t = shifty.getpos(i)
      awful.client.movetotag(t)
      awful.tag.viewonly(t)
    end
  end),
  awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, function()
    if client.focus then
      awful.client.toggletag(shifty.getpos(i))
    end
  end))
end

root.keys(globalkeys)
-- }}}

-- {{{ Signals
client.connect_signal("manage", function(c, startup)
  c:connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
    and awful.client.focus.filter(c) then
      client.focus = c
      -- c:raise()
    end
  end)
  if not startup and not c.size_hints.user_position and not c.size_hints.program_position then
    awful.placement.no_overlap(c)
    awful.placement.no_offscreen(c)
  end
  local titlebars_enabled = false
  -- if awful.client.floating.get(c) == true then
  --  titlebars_enabled = true
  -- end
  if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
    local buttons = awful.util.table.join(
      awful.button({ }, 1, function()
        client.focus = c
        c:raise()
        awful.mouse.client.move(c)
      end),
      awful.button({ }, 3, function()
        client.focus = c
        c:raise()
        awful.mouse.client.resize(c)
      end)
    )
    local right_layout = wibox.layout.fixed.horizontal()
    local middle_layout = wibox.layout.flex.horizontal()
    local title = awful.titlebar.widget.titlewidget(c)
    local layout = wibox.layout.align.horizontal()
    right_layout:add(awful.titlebar.widget.floatingbutton(c))
    right_layout:add(awful.titlebar.widget.maximizedbutton(c))
    right_layout:add(awful.titlebar.widget.stickybutton(c))
    right_layout:add(awful.titlebar.widget.ontopbutton(c))
    right_layout:add(awful.titlebar.widget.closebutton(c))
    title:set_align("center")
    middle_layout:add(title)
    middle_layout:buttons(buttons)
    layout:set_right(right_layout)
    layout:set_middle(middle_layout)
    awful.titlebar(c, { size = 11 }):set_widget(layout)
  end
end)

client.connect_signal("focus", function(c)
  if c.maximized_horizontal == true and c.maximized_vertical == true then
    c.border_color = beautiful.bg_normal
    c:raise()
  else
    c.border_color = beautiful.border_focus
  end
end)
client.connect_signal("unfocus", function(c)
  c.border_color = beautiful.border_normal
end)

client.connect_signal("focus", function(c)
  if c.name == "plugin-container" then
    flash_client = c
    mt = timer({ timeout = 0.0 })
    mt:connect_signal("timeout", function()
      flash_client.fullscreen = true
      mt:stop()
    end)
    mt:start()
  end
end)

for s = 1, screen.count() do
  screen[s]:connect_signal("arrange", function()
    local clients = awful.client.visible(s)
    local layout = awful.layout.getname(awful.layout.get(s))
    if #clients > 0 then
      for _, c in pairs(clients) do
        if awful.client.floating.get(c) or layout == "floating" then
          c.border_width = beautiful.border_width
        elseif #clients == 1 or layout == "max" then
          clients[1].border_width = 0
        else
          c.border_width = beautiful.border_width
        end
      end
    end
  end)
end
-- }}}

pcall(function() jit.on() end)
