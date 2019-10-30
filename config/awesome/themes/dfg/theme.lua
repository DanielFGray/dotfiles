theme                                           = {}
theme.font                                      = "Fira 8"
theme.colors                                    = {}
theme.colors.base3                              = "#131313ee"
theme.colors.base2                              = "#262626"
theme.colors.base1                              = "#586e75"
theme.colors.base0                              = "#657b83"
theme.colors.base00                             = "#839496"
theme.colors.base01                             = "#93a1a1"
theme.colors.base02                             = "#dedede"
theme.colors.base03                             = "#fdf6e3"
theme.colors.yellow                             = "#b58900"
theme.colors.orange                             = "#cb4b16"
theme.colors.red                                = "#dc322f"
theme.colors.magenta                            = "#d33682"
theme.colors.violet                             = "#6c71c4"
theme.colors.blue                               = "#0390c4"
theme.colors.cyan                               = "#2aa198"
theme.colors.green                              = "#859900"
theme.notification_font                         = "Fira Mono 10"

theme.fg_focus                                  = theme.colors.base3
theme.bg_focus                                  = theme.colors.blue

theme.fg_normal                                 = theme.colors.base02
theme.bg_normal                                 = theme.colors.base3

theme.fg_urgent                                 = theme.colors.base03
theme.bg_urgent                                 = theme.colors.red

theme.bg_systray                                = theme.bg_normal

theme.tasklist_bg_focus                         = theme.colors.base3
theme.tasklist_bg_normal                        = theme.colors.base3
theme.tasklist_fg_focus                         = theme.colors.base02
theme.tasklist_fg_normal                        = theme.colors.base1

theme.border_normal                             = theme.bg_normal
theme.border_focus                              = theme.bg_focus
theme.border_marked                             = theme.bg_urgent
theme.border_width                              = 0

theme.layout_fairh                              = beautifultheme .. "layouts/fairh.png"
theme.layout_fairv                              = beautifultheme .. "layouts/fairv.png"
theme.layout_floating                           = beautifultheme .. "layouts/floating.png"
theme.layout_magnifier                          = beautifultheme .. "layouts/magnifier.png"
theme.layout_max                                = beautifultheme .. "layouts/max.png"
theme.layout_fullscreen                         = beautifultheme .. "layouts/fullscreen.png"
theme.layout_tilebottom                         = beautifultheme .. "layouts/tilebottom.png"
theme.layout_tileleft                           = beautifultheme .. "layouts/tileleft.png"
theme.layout_tile                               = beautifultheme .. "layouts/tile.png"
theme.layout_tiletop                            = beautifultheme .. "layouts/tiletop.png"
theme.layout_spiral                             = beautifultheme .. "layouts/spiral.png"
theme.layout_dwindle                            = beautifultheme .. "layouts/dwindle.png"

theme.lain_icons                                = os.getenv("HOME") .. "/.config/awesome/lain/icons/layout/default/"
theme.layout_cascadebrowse                      = theme.lain_icons .. "cascadebrowsew.png"
theme.layout_cascade                            = theme.lain_icons .. "cascadew.png"
theme.layout_centerfair                         = theme.lain_icons .. "centerfairw.png"
theme.layout_centerhwork                        = theme.lain_icons .. "centerhworkw.png"
theme.layout_centerwork                         = theme.lain_icons .. "centerworkw.png"
theme.layout_termfair                           = theme.lain_icons .. "termfairw.png"

theme.awesome_icon                              = beautifultheme .. "icons/awesome.png"
theme.tasklist_floating_icon                    = beautifultheme .. "titlebar/floating_focus_active.png"

theme.menu_submenu_icon                         = "/usr/share/awesome/themes/default/submenu.png"
-- theme.taglist_squares_sel                       = beautifultheme .. "taglist/squarefza.png"
-- theme.taglist_squares_unsel                     = beautifultheme .. "taglist/squareza.png"

theme.wallpaper_cmd                             = { "nitrogen --restore" }
theme.taglist_squares                           = "false"
theme.titlebar_close_button                     = "true"
theme.awful_widget_height                       = "12"
theme.menu_height                               = "16"
theme.menu_width                                = "170"

theme.titlebar_close_button_focus               = beautifultheme .. "titlebar/close_focus.png"
theme.titlebar_close_button_normal              = beautifultheme .. "titlebar/close_normal.png"

theme.titlebar_ontop_button_focus_active        = beautifultheme .. "titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active       = beautifultheme .. "titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive      = beautifultheme .. "titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive     = beautifultheme .. "titlebar/ontop_normal_inactive.png"

theme.titlebar_sticky_button_focus_active       = beautifultheme .. "titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active      = beautifultheme .. "titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive     = beautifultheme .. "titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive    = beautifultheme .. "titlebar/sticky_normal_inactive.png"

theme.titlebar_floating_button_focus_active     = beautifultheme .. "titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active    = beautifultheme .. "titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive   = beautifultheme .. "titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive  = beautifultheme .. "titlebar/floating_normal_inactive.png"

theme.titlebar_maximized_button_focus_active    = beautifultheme .. "titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active   = beautifultheme .. "titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = beautifultheme .. "titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = beautifultheme .. "titlebar/maximized_normal_inactive.png"

theme.widget                                    = {}
theme.widget.cpu                                = beautifultheme .. "icons/cpu.png"
theme.widget.mem                                = beautifultheme .. "icons/mem.png"
theme.widget.music                              = beautifultheme .. "icons/music.png"
theme.widget.clock                              = beautifultheme .. "icons/clock.png"
theme.widget.temp                               = beautifultheme .. "icons/temp.png"
theme.widget.ac                                 = beautifultheme .. "icons/ac.png"
theme.widget.bat_high                           = beautifultheme .. "icons/bat.png"
theme.widget.bat_mid                            = beautifultheme .. "icons/bat2.png"
theme.widget.bat_low                            = beautifultheme .. "icons/bat1.png"
theme.widget.disk                               = beautifultheme .. "icons/disk.png"
theme.widget.netup                              = beautifultheme .. "icons/up.png"
theme.widget.netdown                            = beautifultheme .. "icons/down.png"
theme.widget.pacman                             = beautifultheme .. "icons/pacman.png"

theme.useless_gap                               = 5
theme.gap_single_client                         = false

theme.menu_disable_icon                         = false
theme.tasklist_disable_icon                     = false

theme.modalbind_font = "Fira 14"

-- theme.modalbind_font = theme.notification_font -- font
-- theme.modebox_border_width = 1       -- border width

return theme
