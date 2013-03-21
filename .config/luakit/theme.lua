--------------------------
-- Default luakit theme --
--------------------------

local theme = {}

theme.colors = {}
theme.colors.base3   = "#292929"
theme.colors.base2   = "#383838"
theme.colors.base1   = "#586e75"
theme.colors.base0   = "#657b83"
theme.colors.base00  = "#839496"
theme.colors.base01  = "#93a1a1"
theme.colors.base02  = "#eee8d5"
theme.colors.base03  = "#dedede"
theme.colors.yellow  = "#b58900"
theme.colors.orange  = "#cb4b16"
theme.colors.red     = "#dc322f"
theme.colors.magenta = "#d33682"
theme.colors.violet  = "#6c71c4"
theme.colors.blue    = '#0390c4'
theme.colors.cyan    = "#2aa198"
theme.colors.green   = "#859900"

-- Default settings
theme.font = "Ubuntu Mono 8"
theme.fg   = theme.colors.base03
theme.bg   = theme.colors.base3

-- Genaral colours
theme.success_fg = "#0f0"
theme.loaded_fg  = "#33AADD"
theme.error_fg = "#FFF"
theme.error_bg = "#F00"

-- Warning colours
theme.warning_fg = theme.colors.base03
theme.warning_bg = theme.colors.red

-- Notification colours
theme.notif_fg = "#444"
theme.notif_bg = "#FFF"

-- Menu colours
theme.menu_fg                   = theme.colors.base03
theme.menu_bg                   = theme.colors.base3
theme.menu_selected_fg          = theme.colors.base3
theme.menu_selected_bg          = theme.colors.blue
theme.menu_title_bg             = theme.colors.blue
theme.menu_primary_title_fg     = theme.colors.base3
theme.menu_secondary_title_fg   = theme.colors.base3

-- Proxy manager
theme.proxy_active_menu_fg      = '#000'
theme.proxy_active_menu_bg      = '#FFF'
theme.proxy_inactive_menu_fg    = '#888'
theme.proxy_inactive_menu_bg    = '#FFF'

-- Statusbar specific
theme.sbar_fg         = theme.colors.base03
theme.sbar_bg         = theme.colors.base2

-- Downloadbar specific
theme.dbar_fg         = "#fff"
theme.dbar_bg         = "#000"
theme.dbar_error_fg   = "#F00"

-- Input bar specific
theme.ibar_fg           = theme.colors.base03
theme.ibar_bg           = theme.colors.base3

-- Tab label
theme.tab_fg            = theme.colors.base03
theme.tab_bg            = theme.colors.base2
theme.tab_ntheme        = "#ddd"
theme.selected_fg       = theme.colors.base3
theme.selected_bg       = theme.colors.blue
theme.selected_ntheme   = "#ddd"
theme.loading_fg        = theme.colors.base03
theme.loading_bg        = "#000"

-- Trusted/untrusted ssl colours
theme.trust_fg          = theme.colors.green
theme.notrust_fg        = theme.colors.red
return theme
-- vim: et:sw=4:ts=8:sts=4:tw=80
