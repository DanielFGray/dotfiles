theme                = {}
theme.font           = "Ubuntu Mono 8"
theme.taglist_font   = "Ubuntu Mono Bold 8"
theme.tasklist_font  = "Ubuntu Mono Bold 8"
theme.colors         = {}
theme.colors.base3   = "#002b36"
theme.colors.base2   = "#073642"
theme.colors.base1   = "#586e75"
theme.colors.base0   = "#657b83"
theme.colors.base00  = "#839496"
theme.colors.base01  = "#93a1a1"
theme.colors.base02  = "#eee8d5"
theme.colors.base03  = "#fdf6e3"
theme.colors.yellow  = "#b58900"
theme.colors.orange  = "#cb4b16"
theme.colors.red     = "#dc322f"
theme.colors.magenta = "#d33682"
theme.colors.violet  = "#6c71c4"
theme.colors.blue    = "#268bd2"
theme.colors.cyan    = "#2aa198"
theme.colors.green   = "#859900"

theme.fg_normal  = theme.colors.base02
theme.fg_focus   = theme.colors.base3
theme.fg_urgent  = theme.colors.base03

theme.bg_normal  = theme.colors.base3
theme.bg_focus   = theme.colors.blue
theme.bg_urgent  = theme.colors.red
theme.bg_systray = theme.bg_normal

theme.border_normal = theme.bg_normal
theme.border_focus  = theme.bg_focus
theme.border_marked = theme.bg_urgent
theme.border_width  = "1"

theme.layout_fairh           = "/usr/share/awesome/themes/zenburn/layouts/fairh.png"
theme.layout_fairv           = "/usr/share/awesome/themes/zenburn/layouts/fairv.png"
theme.layout_floating        = "/usr/share/awesome/themes/zenburn/layouts/floating.png"
theme.layout_magnifier       = "/usr/share/awesome/themes/zenburn/layouts/magnifier.png"
theme.layout_max             = "/usr/share/awesome/themes/zenburn/layouts/max.png"
theme.layout_fullscreen      = "/usr/share/awesome/themes/zenburn/layouts/fullscreen.png"
theme.layout_tilebottom      = "/usr/share/awesome/themes/zenburn/layouts/tilebottom.png"
theme.layout_tileleft        = "/usr/share/awesome/themes/zenburn/layouts/tileleft.png"
theme.layout_tile            = "/usr/share/awesome/themes/zenburn/layouts/tile.png"
theme.layout_tiletop         = "/usr/share/awesome/themes/zenburn/layouts/tiletop.png"
theme.layout_spiral          = "/usr/share/awesome/themes/zenburn/layouts/spiral.png"
theme.layout_dwindle         = "/usr/share/awesome/themes/zenburn/layouts/dwindle.png"

theme.awesome_icon           = "/home/dan/.config/awesome/icons/awesome.png"
theme.tasklist_floating_icon = "/home/dan/.config/awesome/icons/titlebar/floating_focus_active.png"

theme.menu_submenu_icon     = "/usr/share/awesome/themes/default/submenu.png"
theme.taglist_squares_sel   = "/home/dan/.config/awesome/icons/taglist/squarefza.png"
theme.taglist_squares_unsel = "/home/dan/.config/awesome/icons/taglist/squareza.png"

--theme.wallpaper_cmd         = { "awsetbg /usr/share/awesome/themes/sky/sky-background.png" }
theme.wallpaper_cmd         = { "nitrogen --restore" }
theme.taglist_squares       = "true"
theme.titlebar_close_button = "true"
theme.menu_height           = "15"
theme.menu_width            = "170"

theme.titlebar_close_button_normal = "/home/dan/.config/awesome/icons/titlebar/close_normal.png"
theme.titlebar_close_button_focus = "/home/dan/.config/awesome/icons/titlebar/close_focus.png"

theme.titlebar_ontop_button_normal_inactive = "/home/dan/.config/awesome/icons/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive = "/home/dan/.config/awesome/icons/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = "/home/dan/.config/awesome/icons/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active = "/home/dan/.config/awesome/icons/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = "/home/dan/.config/awesome/icons/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive = "/home/dan/.config/awesome/icons/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = "/home/dan/.config/awesome/icons/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active = "/home/dan/.config/awesome/icons/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = "/home/dan/.config/awesome/icons/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive = "/home/dan/.config/awesome/icons/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = "/home/dan/.config/awesome/icons/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active = "/home/dan/.config/awesome/icons/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = "/home/dan/.config/awesome/icons/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive = "/home/dan/.config/awesome/icons/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = "/home/dan/.config/awesome/icons/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active = "/home/dan/.config/awesome/icons/titlebar/maximized_focus_active.png"

return theme
