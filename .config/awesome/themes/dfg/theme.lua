theme                = {}
theme.font           = 'Monaco 7'
theme.taglist_font   = 'Monaco Bold 7'
theme.tasklist_font  = 'Monaco Bold 7'
theme.colors         = {}
--theme.colors.base3   = '#383838e6'
theme.colors.base3   = '#292929'
theme.colors.base2   = '#363636'
theme.colors.base1   = '#586e75'
theme.colors.base0   = '#657b83'
theme.colors.base00  = '#839496'
theme.colors.base01  = '#93a1a1'
theme.colors.base02  = '#dedede'
theme.colors.base03  = '#fdf6e3'
theme.colors.yellow  = '#b58900'
theme.colors.orange  = '#cb4b16'
theme.colors.red     = '#dc322f'
theme.colors.magenta = '#d33682'
theme.colors.violet  = '#6c71c4'
theme.colors.blue    = '#0390c4'
theme.colors.cyan    = '#2aa198'
theme.colors.green   = '#859900'

theme.fg_focus   = theme.colors.base3
theme.bg_focus   = theme.colors.blue

theme.fg_normal  = theme.colors.base02
theme.bg_normal  = theme.colors.base3

theme.fg_urgent  = theme.colors.base03
theme.bg_urgent  = theme.colors.red

theme.bg_systray = theme.bg_normal

theme.border_normal = theme.bg_normal
theme.border_focus  = theme.bg_focus
theme.border_marked = theme.bg_urgent
theme.border_width  = '1'

theme.layout_fairh           = beautifultheme..'layouts/fairh.png'
theme.layout_fairv           = beautifultheme..'layouts/fairv.png'
theme.layout_floating        = beautifultheme..'layouts/floating.png'
theme.layout_magnifier       = beautifultheme..'layouts/magnifier.png'
theme.layout_max             = beautifultheme..'layouts/max.png'
theme.layout_fullscreen      = beautifultheme..'layouts/fullscreen.png'
theme.layout_tilebottom      = beautifultheme..'layouts/tilebottom.png'
theme.layout_tileleft        = beautifultheme..'layouts/tileleft.png'
theme.layout_tile            = beautifultheme..'layouts/tile.png'
theme.layout_tiletop         = beautifultheme..'layouts/tiletop.png'
theme.layout_spiral          = beautifultheme..'layouts/spiral.png'
theme.layout_dwindle         = beautifultheme..'layouts/dwindle.png'

theme.awesome_icon           = beautifultheme..'icons/awesome.png'
theme.tasklist_floating_icon = beautifultheme..'titlebar/floating_focus_active.png'

theme.menu_submenu_icon     = '/usr/share/awesome/themes/default/submenu.png'
theme.taglist_squares_sel   = beautifultheme..'taglist/squarefza.png'
theme.taglist_squares_unsel = beautifultheme..'taglist/squareza.png'

--theme.wallpaper_cmd         = { 'awsetbg /usr/share/awesome/themes/sky/sky-background.png' }
theme.wallpaper_cmd         = { 'nitrogen --restore' }
theme.taglist_squares       = 'true'
theme.titlebar_close_button = 'true'
theme.menu_height           = '16'
theme.menu_width            = '170'

theme.titlebar_close_button_normal = beautifultheme..'titlebar/close_normal.png'
theme.titlebar_close_button_focus =  beautifultheme..'titlebar/close_focus.png'

theme.titlebar_ontop_button_normal_inactive = beautifultheme..'titlebar/ontop_normal_inactive.png'
theme.titlebar_ontop_button_focus_inactive =  beautifultheme..'titlebar/ontop_focus_inactive.png'
theme.titlebar_ontop_button_normal_active =   beautifultheme..'titlebar/ontop_normal_active.png'
theme.titlebar_ontop_button_focus_active =    beautifultheme..'titlebar/ontop_focus_active.png'

theme.titlebar_sticky_button_normal_inactive = beautifultheme..'titlebar/sticky_normal_inactive.png'
theme.titlebar_sticky_button_focus_inactive =  beautifultheme..'titlebar/sticky_focus_inactive.png'
theme.titlebar_sticky_button_normal_active =   beautifultheme..'titlebar/sticky_normal_active.png'
theme.titlebar_sticky_button_focus_active =    beautifultheme..'titlebar/sticky_focus_active.png'

theme.titlebar_floating_button_normal_inactive = beautifultheme..'titlebar/floating_normal_inactive.png'
theme.titlebar_floating_button_focus_inactive =  beautifultheme..'titlebar/floating_focus_inactive.png'
theme.titlebar_floating_button_normal_active =   beautifultheme..'titlebar/floating_normal_active.png'
theme.titlebar_floating_button_focus_active =    beautifultheme..'titlebar/floating_focus_active.png'

theme.titlebar_maximized_button_normal_inactive = beautifultheme..'titlebar/maximized_normal_inactive.png'
theme.titlebar_maximized_button_focus_inactive =  beautifultheme..'titlebar/maximized_focus_inactive.png'
theme.titlebar_maximized_button_normal_active =   beautifultheme..'titlebar/maximized_normal_active.png'
theme.titlebar_maximized_button_focus_active =    beautifultheme..'titlebar/maximized_focus_active.png'

return theme
