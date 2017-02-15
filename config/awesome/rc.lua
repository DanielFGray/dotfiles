-- Standard awesome library
gears = require("gears")
awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
wibox = require("wibox")
-- Theme handling library
beautiful = require("beautiful")
-- Notification library
naughty = require("naughty")
menubar = require("menubar")
hotkeys_popup = require("awful.hotkeys_popup").widget
tyrannical = require("tyrannical")
lain = require("lain")
treetile = require("treetile")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
  naughty.notify({
    preset = naughty.config.presets.critical,
    title = "There were errors during startup",
    text = awesome.startup_errors
  })
end

-- Handle runtime errors after startup
do
  local in_error = false
  awesome.connect_signal("debug::error", function(err)
    -- Make sure we don't go into an endless error loop
    if in_error then return end
    in_error = true
    naughty.notify({
      preset = naughty.config.presets.critical,
      title = "An error happened",
      text = tostring(err)
    })
    in_error = false
  end)
end
-- }}}

-- {{{ Variable definitions

terminal = "x-terminal-emulator"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

exec = awful.util.spawn
sexec = awful.util.spawn_with_shell
homedir = os.getenv("HOME") .. "/"
configdir = awful.util.getdir("config") .. "/"
beautifultheme = configdir .. "themes/dfg/"

-- Themes define colours, icons, font and wallpapers.
-- beautiful.init(awful.util.get_themes_dir() .. "default/theme.lua")
beautiful.init(beautifultheme .. "theme.lua")

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
  awful.layout.suit.floating,
  treetile,
  awful.layout.suit.tile,
  -- awful.layout.suit.tile.left,
  -- awful.layout.suit.tile.bottom,
  -- awful.layout.suit.tile.top,
  -- awful.layout.suit.fair,
  -- awful.layout.suit.fair.horizontal,
  -- awful.layout.suit.spiral,
  -- awful.layout.suit.spiral.dwindle,
  -- awful.layout.suit.max,
  -- awful.layout.suit.max.fullscreen,
  -- awful.layout.suit.magnifier,
  -- awful.layout.suit.corner.nw,
  -- awful.layout.suit.corner.ne,
  -- awful.layout.suit.corner.sw,
  -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Tags
tyrannical.tags = {
  {
    name        = "term",                 -- Call the tag "Term"
    init        = false,                  -- Load the tag on startup
    exclusive   = true,                   -- Refuse any other type of clients (by classes)
    layout      = treetile,
    instance    = { "dev", "ops" },       -- Accept the following instances. This takes precedence over 'class'
    volatile    = true,
    class       = {                       -- Accept the following classes, refuse everything else (because of "exclusive=true")
      terminal,
      "xterm",
      "urxvt",
      "aterm",
      "URxvt",
      "XTerm",
      "konsole",
      "terminator",
      "gnome-terminal",
      ".*term.*",
      "st-*",
    }
  }, {
    name        = "web",
    init        = false,
    exclusive   = true,
    -- icon        = "~net.png",                  -- Use this icon for the tag (uncomment with a real path)
    screen      = screen.count() > 1 and 2 or 1, -- Setup on screen 2 if there is more than 1 screen, else on screen 1
    layout      = treetile,
    volatile    = true,
    class = {
      "Opera",
      "Firefox",
      "Rekonq",
      "Dillo",
      "Arora",
      "Chromium",
      "nightly",
      "minefield",
      "Firefox",
      "Iceweasel",
      "Vimperator",
      "Pentadactyl",
      "chromium",
      "google.chrome.*",
      "luakit",
      "Nightly",
      "uzbl",
      "dwb",
      "qutebrowser",
      "glide",
      "brave",
    }
  },
}

-- Ignore the tag "exclusive" property for the following clients (matched by classes)
tyrannical.properties.intrusive = {
  "Thunar",
  "Konqueror",
  "Dolphin",
  "ark",
  "Nautilus",
  "emelfm",
  "ksnapshot",
  "pinentry",
  "gtksu",
  "kcalc",
  "xcalc",
  "feh",
  "Gradient editor",
  "About KDE",
  "Paste Special",
  "Background color",
  "kcolorchooser",
  "plasmoidviewer",
  "Xephyr",
  "kruler",
  "plasmaengineexplorer",
}

-- Ignore the tiled layout for the matching clients
tyrannical.properties.floating = {
  "MPlayer",
  "pinentry",
  "ksnapshot",
  "pinentry",
  "gtksu",
  "xine",
  "feh",
  "kmix",
  "kcalc",
  "xcalc",
  "yakuake",
  "Select Color$",
  "kruler",
  "kcolorchooser",
  "Paste Special",
  "New Form",
  "Insert Picture",
  "kcharselect",
  "mythfrontend",
  "plasmoidviewer",
}

-- Make the matching clients (by classes) on top of the default layout
tyrannical.properties.ontop = {
  "Xephyr",
  "ksnapshot",
  "kruler",
}

-- Force the matching clients (by classes) to be centered on the screen on init
tyrannical.properties.placement = {
  kcalc = awful.placement.centered
}

tyrannical.settings.block_children_focus_stealing = true --Block popups ()
tyrannical.settings.group_children = true --Force popups/dialogs to have the same tags as the parent client
-- }}}

-- {{{ Helper functions
local function client_menu_toggle_fn()
  local instance = nil

  return function()
    if instance and instance.wibox.visible then
      instance:hide()
      instance = nil
    else
        instance = awful.menu.clients({ theme = { width = 250 } })
    end
  end
end

function run_once(cmd)
  local findme = cmd
  local firstspace = cmd:find(" ")
  if firstspace then
    findme = cmd:gsub(0, firstspace - 1)
  end
  sexec("pgrep -i -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end

exec("nitrogen --restore")
run_once("urxvtd -q -f")
run_once("compton --config ~/.compton.conf")
run_once("clipit")
run_once("nm-applet")
run_once("pnmixer")
run_once("xfce4-power-manager")
run_once("redshift-gtk lat=29.27 lon=-94.87")
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() return false, hotkeys_popup.show_help end},
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end}
}

mymainmenu = awful.menu({
  items = {
    { "awesome", myawesomemenu, beautiful.awesome_icon },
    { "open terminal", terminal }
  }
})

mylauncher = awful.widget.launcher({
  image = beautiful.awesome_icon,
  menu = mymainmenu
})

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibar
markup = lain.util.markup
space = wibox.widget.textbox(" ")
lsep = wibox.widget.textbox(markup("#666", " "))

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- Create a textclock widget
mytextclock = wibox.widget.textclock(" %r ", 1)
lain.widgets.calendar:attach(mytextclock)

local cpuicon = wibox.widget.imagebox(beautiful.widget_cpu)
local cpuwidget = lain.widgets.cpu({
  settings = function()
    widget:set_markup(string.format("%02d", cpu_now.usage) .. markup("#666", "% "))
  end
})

local memicon = wibox.widget.imagebox(beautiful.widget_mem)
local memwidget = lain.widgets.mem({
  settings = function()
    widget:set_markup(mem_now.used .. markup("#666", "MB "))
  end
})

local tempicon = wibox.widget.imagebox(beautiful.widget_temp)
local tempwidget = lain.widgets.temp({
  settings = function()
    widget:set_markup(coretemp_now .. markup("#666", "°C "))
  end
})

local fsicon = wibox.widget.imagebox(beautiful.widget_hdd)
local fswidget = lain.widgets.fs({
  settings = function()
    widget:set_markup(fs_now.used .. markup("#666", "% "))
  end
})

local netupicon = wibox.widget.imagebox(beautiful.widget_netup)
local netupwidget = lain.widgets.net({
  settings = function()
    local data = tostring(net_now.sent):gsub("^0.%d", "0")
    data = data:gsub(".0$", "")
    widget:set_markup(data .. "K ")
  end
})

local netdownicon = wibox.widget.imagebox(beautiful.widget_netdown)
local netdownwidget = lain.widgets.net({
  settings = function()
    local data = tostring(net_now.received):gsub("^0.%d", "0")
    data = data:gsub(".0$", "")
    widget:set_markup(data .. "K ")
  end
})

local mpdicon = wibox.widget.imagebox(beautiful.widget_music)
local mpdwidget = lain.widgets.mpd({
  settings = function()
    artist = ""
    title = ""
    if mpd_now.state == "play" then
      artist = mpd_now.artist .. " - "
      title = mpd_now.title .. " "
    elseif mpd_now.state == "pause" then
      artist = markup("#666", mpd_now.artist .. " - ")
      title = markup("#666", mpd_now.title)
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

-- Create a wibox for each screen and add it
local taglist_buttons = awful.util.table.join(
  awful.button({ }, 1, function(t) t:view_only() end),
  awful.button({ modkey }, 1, function(t)
    if client.focus then
      client.focus:move_to_tag(t)
    end
  end),
  awful.button({ }, 3, awful.tag.viewtoggle),
  awful.button({ modkey }, 3, function(t)
    if client.focus then
      client.focus:toggle_tag(t)
    end
  end),
  awful.button({ }, 4, function(t)
    awful.tag.viewnext(t.screen)
  end),
  awful.button({ }, 5, function(t)
    awful.tag.viewprev(t.screen)
  end)
)

local tasklist_buttons = awful.util.table.join(
  awful.button({ }, 1, function(c)
    if c == client.focus then
      c.minimized = true
    else
      -- Without this, the following
      -- :isvisible() makes no sense
      c.minimized = false
      if not c:isvisible() and c.first_tag then
        c.first_tag:view_only()
      end
      -- This will also un-minimize
      -- the client, if needed
      client.focus = c
      c:raise()
    end
  end),
  awful.button({ }, 3, client_menu_toggle_fn()),
  awful.button({ }, 4, function()
    awful.client.focus.byidx(1)
  end),
  awful.button({ }, 5, function()
    awful.client.focus.byidx(-1)
  end)
)

local function set_wallpaper(s)
  -- Wallpaper
  if beautiful.wallpaper then
    local wallpaper = beautiful.wallpaper
    -- If wallpaper is a function, call it with the screen
    if type(wallpaper) == "function" then
      wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)
  else
    sexec("nitrogen --restore")
  end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
  -- Wallpaper
  set_wallpaper(s)

  -- Create a promptbox for each screen
  s.mypromptbox = awful.widget.prompt()

  -- Create an imagebox widget which will contains an icon indicating which layout we're using.
  -- We need one layoutbox per screen.
  s.mylayoutbox = awful.widget.layoutbox(s)
  s.mylayoutbox:buttons(awful.util.table.join(
    awful.button({ }, 1, function() awful.layout.inc(1) end),
    awful.button({ }, 3, function() awful.layout.inc(-1) end),
    awful.button({ }, 4, function() awful.layout.inc(1) end),
    awful.button({ }, 5, function() awful.layout.inc(-1) end)
  ))

  -- Create a taglist widget
  s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

  -- Create a tasklist widget
  s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

  -- Create the wibox
  s.mywibox = awful.wibar({ position = "bottom", screen = s, height = 12 })

  -- Add widgets to the wibox
  s.mywibox:setup {
    layout = wibox.layout.align.horizontal, {
    -- Left widgets
    layout = wibox.layout.fixed.horizontal,
      -- mylauncher,
      s.mytaglist,
      s.mylayoutbox,
      s.mypromptbox,
    },
    s.mytasklist, -- Middle widget
    { -- Right widgets
      layout = wibox.layout.fixed.horizontal,
      mykeyboardlayout,
      lsep,
      mpdicon, space, mpdwidget,
      lsep,
      netupicon, space, netupwidget,
      netdownicon, space, netdownwidget,
      lsep,
      fsicon, space, fswidget,
      lsep,
      tempicon, space, tempwidget,
      lsep,
      memicon, space, memwidget,
      lsep,
      cpuicon, space, cpuwidget,
      lsep,
      wibox.widget.systray(),
      mytextclock,
    },
  }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
  awful.button({ }, 3, function() mymainmenu:toggle() end),
  awful.button({ }, 4, awful.tag.viewnext),
  awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
  awful.key({ modkey }, "s", function()
    hotkeys_popup.show_help()
  end, { description = "show help", group = "awesome" }),

  awful.key({ modkey }, "Left", function()
    awful.tag.viewprev()
  end, { description = "view previous", group = "tag" }),

  awful.key({ modkey }, "Right", function()
    awful.tag.viewnext()
  end, { description = "view next", group = "tag" }),

  awful.key({ modkey }, "Escape", function()
    awful.tag.history.restore()
  end, { description = "go back", group = "tag" }),

  awful.key({ modkey }, "j", function()
    awful.client.focus.byidx(1)
  end, { description = "focus next by index", group = "client" }),

  awful.key({ modkey }, "k", function()
    awful.client.focus.byidx(-1)
  end, { description = "focus previous by index", group = "client" }),

  -- awful.key({ modkey }, "w", function()
  --   mymainmenu:show()
  -- end, { description = "show main menu", group = "awesome" }),

  -- Layout manipulation
  awful.key({ modkey, "Shift" }, "j", function()
    awful.client.swap.byidx(1)
  end, { description = "swap with next client by index", group = "client" }),

  awful.key({ modkey, "Shift" }, "k", function()
    awful.client.swap.byidx(-1)
  end, { description = "swap with previous client by index", group = "client" }),

  awful.key({ modkey, "Control" }, "j", function()
    awful.screen.focus_relative(1)
  end, { description = "focus the next screen", group = "screen" }),

  awful.key({ modkey, "Control" }, "k", function()
    awful.screen.focus_relative(-1)
  end, { description = "focus the previous screen", group = "screen" }),

  awful.key({ modkey }, "u", function()
    awful.client.urgent.jumpto()
  end, { description = "jump to urgent client", group = "client" }),

  awful.key({ modkey }, "Tab", function()
    awful.client.focus.history.previous()
    if client.focus then
      client.focus:raise()
    end
  end, { description = "go back", group = "client" }),

  -- Standard program
  awful.key({ modkey }, "Return", function()
    awful.spawn(terminal)
  end, { description = "open a terminal", group = "launcher" }),

  awful.key({ modkey, "Control" }, "r", function()
    awesome.restart()
  end, { description = "reload awesome", group = "awesome" }),

  awful.key({ modkey, "Shift" }, "q", function()
    awesome.quit()
  end, { description = "quit awesome", group = "awesome" }),

  awful.key({ modkey }, "l", function()
    awful.tag.incmwfact(0.05)
  end, { description = "increase master width factor", group = "layout" }),

  awful.key({ modkey, }, "h", function()
    awful.tag.incmwfact(-0.05)
  end, { description = "decrease master width factor", group = "layout" }),

  awful.key({ modkey, "Shift" }, "h", function()
    awful.tag.incnmaster(1, nil, true)
  end, { description = "increase the number of master clients", group = "layout" }),

  awful.key({ modkey, "Shift" }, "l", function()
    awful.tag.incnmaster(-1, nil, true)
  end, { description = "decrease the number of master clients", group = "layout" }),

  awful.key({ modkey, "Control" }, "h", function()
    awful.tag.incncol(1, nil, true)
  end, { description = "increase the number of columns", group = "layout" }),

  awful.key({ modkey, "Control" }, "l", function()
    awful.tag.incncol(-1, nil, true)
  end, { description = "decrease the number of columns", group = "layout" }),

  awful.key({ modkey }, "space", function()
    awful.layout.inc(1)
  end, { description = "select next", group = "layout" }),

  awful.key({ modkey, "Shift" }, "space", function()
    awful.layout.inc(-1)
  end, { description = "select previous", group = "layout" }),

  awful.key({ modkey, "Control" }, "n", function()
    local c = awful.client.restore()
    -- Focus restored client
    if c then
      client.focus = c
      c:raise()
    end
  end, { description = "restore minimized", group = "client" }),

  awful.key({ modkey }, "F4", function()
    awful.prompt.run {
      prompt       = "Run Lua code: ",
      textbox      = awful.screen.focused().mypromptbox.widget,
      exe_callback = awful.util.eval,
      history_path = awful.util.get_cache_dir() .. "/history_eval"
    }
  end, { description = "lua eval prompt", group = "awesome" }),

  -- Launchers
  awful.key({ modkey }, "p", function()
    menubar.show()
  end, { description = "show the menubar", group = "launcher" }),

  awful.key({ modkey }, "r", function()
    -- awful.screen.focused().mypromptbox:run()
    sexec("dmenu_run -b -z -fn 'Fantasque Sans Mono-8' -nb '#131313'")
  end, { description = "run dmenu", group = "launcher" }),

  -- Tag management
  awful.key({ modkey, "Shift" }, "a", function()
    awful.prompt.run {
      prompt       = "New tag name: ",
      textbox      = awful.screen.focused().mypromptbox.widget,
      exe_callback = function(new_name)
        if not new_name or #new_name == 0 then return end
      end
    }
  end, { description = "add new", group = "tag" }),

  awful.key({ modkey, "Shift" }, "r", function()
    awful.prompt.run {
      prompt       = "New tag name: ",
      textbox      = awful.screen.focused().mypromptbox.widget,
      exe_callback = function(new_name)
        if not new_name or #new_name == 0 then return end
        local t = awful.screen.focused().selected_tag
        if t then
            t.name = new_name
        end
      end
    }
  end, { description = "rename", group = "tag" }),

  awful.key({ modkey }, "Print", function()
    sexec("yaxg -w -D1")
  end, { description = "screencast whole screen", group = "launcher" }),

  awful.key({ modkey, "Shift" }, "Print", function()
    sexec("yaxg -w -D1 -s")
  end, { description = "screencast a selection", group = "launcher" }),

  awful.key({ }, "Print", function()
    sexec("yaxg -D1")
  end, { description = "screenshot whole screen", group = "launcher" }),

  awful.key({ "Shift" }, "Print", function()
    sexec("yaxg -D1 -s")
  end, { description = "screenshot a selection", group = "launcher" }),

  awful.key({ }, "XF86AudioRaiseVolume", function()
    sexec("amixer -q sset Master 2%+")
  end),
  awful.key({ }, "XF86AudioLowerVolume", function()
    sexec("amixer -q sset Master 2%-")
  end),
  awful.key({ }, "XF86AudioMute", function()
    sexec("amixer -q sset Master toggle")
  end),
  awful.key({ modkey }, "F12", function()
    sexec("mylock --suspend")
  end),
  awful.key({ modkey }, "v", treetile.vertical),
  awful.key({ modkey }, "h", treetile.horizontal),

  awful.key({ modkey }, "o", function(c)
    awful.client.cycle(true, s)
    awful.client.jumpto(awful.client.getmaster())
  end),

  awful.key({ modkey, "Shift" }, "o", function(c)
    awful.client.cycle(false, s)
    awful.client.jumpto(awful.client.getmaster())
  end)
)

clientkeys = awful.util.table.join(
  awful.key({ modkey }, "f", function(c)
    c.fullscreen = not c.fullscreen
    c:raise()
  end, { description = "toggle fullscreen", group = "client" }),

  awful.key({ modkey }, "x", function(c)
    c:kill()
  end, { description = "close", group = "client" }),

  awful.key({ modkey, "Control" }, "space", function()
    awful.client.floating.toggle()
  end, { description = "toggle floating", group = "client" }),

  awful.key({ modkey, "Control" }, "Return", function(c)
    c:swap(awful.client.getmaster())
  end, { description = "move to master", group = "client" }),

  awful.key({ modkey }, "o", function(c)
   c:move_to_screen()
  end, { description = "move to screen", group = "client" }),

  awful.key({ modkey }, "t", function(c)
    c.ontop = not c.ontop
  end, { description = "toggle keep on top", group = "client" }),

  awful.key({ modkey }, "n", function(c)
    -- The client currently has the input focus, so it cannot be
    -- minimized, since minimized clients can't have the focus.
    c.minimized = true
  end , { description = "minimize", group = "client" }),

  awful.key({ modkey }, "m", function(c)
    c.maximized = not c.maximized
    c:raise()
  end , { description = "maximize", group = "client" })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
  globalkeys = awful.util.table.join(globalkeys,
    -- View tag only.
    awful.key({ modkey }, "#" .. i + 9, function()
      local screen = awful.screen.focused()
      local tag = screen.tags[i]
      if tag then
        tag:view_only()
      end
    end, { description = "view tag #"..i, group = "tag" }),

    -- Toggle tag display.
    awful.key({ modkey, "Control" }, "#" .. i + 9, function()
      local screen = awful.screen.focused()
      local tag = screen.tags[i]
      if tag then
        awful.tag.viewtoggle(tag)
      end
    end, { description = "toggle tag #" .. i, group = "tag" }),

    -- Move client to tag.
    awful.key({ modkey, "Shift" }, "#" .. i + 9, function()
      if client.focus then
        local tag = client.focus.screen.tags[i]
        if tag then
          client.focus:move_to_tag(tag)
        end
       end
    end, { description = "move focused client to tag #"..i, group = "tag" }),

    -- Toggle tag on focused client.
    awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, function()
      if client.focus then
        local tag = client.focus.screen.tags[i]
        if tag then
          client.focus:toggle_tag(tag)
        end
      end
    end, { description = "toggle focused client on tag #" .. i, group = "tag" })
  )
end

clientbuttons = awful.util.table.join(
  awful.button({ }, 1, function(c) client.focus = c; c:raise() end),
  awful.button({ modkey }, 1, awful.mouse.client.move),
  awful.button({ modkey }, 3, awful.mouse.client.resize)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
  -- All clients will match this rule.
  { rule = { },
    properties = {
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus = awful.client.focus.filter,
      raise = true,
      keys = clientkeys,
      buttons = clientbuttons,
      screen = awful.screen.preferred,
      placement = awful.placement.no_overlap+awful.placement.no_offscreen,
      size_hints_honor = false,
    }
  },

  -- Floating clients.
  { rule_any = {
      instance = {
        "DTA",  -- Firefox addon DownThemAll.
        "copyq",  -- Includes session name in class.
      },
      class = {
        "Arandr",
        "Gpick",
        "Kruler",
        "MessageWin",  -- kalarm.
        "Sxiv",
        "Wpa_gui",
        "pinentry",
        "veromix",
        "xtightvncviewer",
        "zenity",
      },
      name = {
        "Event Tester",  -- xev.
      },
      role = {
        "AlarmWindow",  -- Thunderbird's calendar.
        "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
      }
    }, properties = { floating = true }},

  -- Add titlebars to normal clients and dialogs
  { rule_any = { type = { "normal", "dialog" }
    }, properties = { titlebars_enabled = false }
  },

  -- Set Firefox to always map on the tag named "2" on screen 1.
  -- { rule = { class = "Firefox" },
  --   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
  -- Set the windows at the slave,
  -- i.e. put it at the end of others instead of setting it master.
  -- if not awesome.startup then awful.client.setslave(c) end

  if awesome.startup and
    not c.size_hints.user_position
    and not c.size_hints.program_position then
      -- Prevent clients from being unreachable after screen count changes.
      awful.placement.no_offscreen(c)
  end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
  -- buttons for the titlebar
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

  awful.titlebar(c) : setup {
    { -- Left
      awful.titlebar.widget.iconwidget(c),
      buttons = buttons,
      layout  = wibox.layout.fixed.horizontal
    },
    { -- Middle
      { -- Title
        align  = "center",
        widget = awful.titlebar.widget.titlewidget(c)
      },
      buttons = buttons,
      layout  = wibox.layout.flex.horizontal
    },
    { -- Right
      awful.titlebar.widget.floatingbutton(c),
      awful.titlebar.widget.maximizedbutton(c),
      awful.titlebar.widget.stickybutton(c),
      awful.titlebar.widget.ontopbutton(c),
      awful.titlebar.widget.closebutton(c),
      layout = wibox.layout.fixed.horizontal()
    },
    layout = wibox.layout.align.horizontal
  }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
  if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
    and awful.client.focus.filter(c) then
    client.focus = c
  end
end)

client.connect_signal("focus", function(c)
  c.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus", function(c)
  c.border_color = beautiful.border_normal
end)
-- }}}

pcall(function() jit.on() end)
