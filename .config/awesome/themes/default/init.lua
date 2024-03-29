---------------------------
-- Default awesome theme --
---------------------------

local theme_assets                              = require("beautiful.theme_assets")
local xresources                                = require("beautiful.xresources")
local dpi                                       = xresources.apply_dpi

local gfs                                       = require("gears.filesystem")
local themes_path                               = gfs.get_themes_dir()

local theme                                     = {}
local colors                                    = require('themes.default.tokyonight-darker')

theme.white                                     = '#FFFFFF'
theme.black                                     = '#000000'
theme.transparent                               = '#00000000'

theme.font                                      = "Robotomono nerd font 8"

theme.useless_gap                               = dpi(0)
theme.border_width                              = dpi(1)

theme.menu_bg_normal                            = colors.color_dark4 .. "60"
theme.menu_bg_focus                             = colors.color_dark3 .. "60"

theme.bg_solid                                  = colors.color_dark4
theme.bg_normal                                 = colors.color_dark4
theme.bg_focus                                  = colors.color_dark3
theme.bg_urgent                                 = colors.color_dark4
theme.fg_normal                                 = colors.color_fg
theme.fg_focus                                  = colors.color_blue
theme.fg_urgent                                 = colors.color_yellow
theme.fg_minimize                               = colors.color_fg
--theme.bg_minimize                               = colors.colors.color14
theme.bg_systray                                = theme.bg_normal

theme.border_width                              = dpi(1)
theme.border_radius                             = dpi(7)
theme.border_normal                             = colors.color_dark3 .. "30"
theme.border_focus                              = colors.color_dark2 .. "30"
theme.border_marked                             = colors.color_dark3 .. "30"
theme.menu_border_width                         = 0
theme.menu_width                                = dpi(130)
theme.menu_fg_normal                            = colors.color_fg
theme.menu_fg_focus                             = colors.color_orange
theme.menu_bg_normal                            = "#050505dd"
theme.menu_bg_focus                             = "#050505dd"
theme.taglist_fg_focus                          = colors.color_dark4
theme.taglist_fg_empty                          = colors.color_dark2
theme.taglist_bg_focus                          = colors.color_blue_light

theme.tabbar_color_close                        = "#f9929b" -- chnges the color of the close button
theme.tabbar_color_min                          = "#fbdf90" -- chnges the color of the minimize button
theme.tabbar_color_float                        = "#ccaced"
theme.tabbar_bg_normal                          = theme.bg_normal ..
    "90"       -- background color of the focused client on the tabbar
theme.tabbar_fg_normal                          = theme
    .fg_normal -- foreground color of the focused client on the tabbar
theme.tabbar_bg_focus                           = colors.color_dark2 ..
    "90"       -- background color of unfocused clients on the tabbar
theme.tabbar_fg_focus                           = theme
    .fg_focus  -- foreground color of unfocused clients on the tabbar
-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = "#ff0000"
theme.tasklist_disable_task_name                = true
-- Generate taglist squares:
local taglist_square_size                       = dpi(4)
theme.taglist_squares_sel                       = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel                     = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

theme.notification_border_color                 = theme.fg_focus 
theme.notification_border_width                 = 2
theme.notification_icon_size                    = dpi(50)
theme.notification_width                        = dpi(350)
theme.notification_max_width                    = dpi(350)
theme.notification_height                       = dpi(80)
theme.notification_max_height                   = dpi(100)
-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon                         = themes_path .. "default/submenu.png"
theme.menu_height                               = dpi(15)
theme.menu_width                                = dpi(100)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal              = themes_path .. "default/titlebar/close_normal.png"
theme.titlebar_close_button_focus               = themes_path .. "default/titlebar/close_focus.png"

theme.titlebar_minimize_button_normal           = themes_path .. "default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus            = themes_path .. "default/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive     = themes_path .. "default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive      = themes_path .. "default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active       = themes_path .. "default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active        = themes_path .. "default/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive    = themes_path .. "default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive     = themes_path .. "default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active      = themes_path .. "default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active       = themes_path .. "default/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive  = themes_path .. "default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive   = themes_path .. "default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active    = themes_path .. "default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active     = themes_path .. "default/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = themes_path .. "default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = themes_path .. "default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active   = themes_path .. "default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active    = themes_path .. "default/titlebar/maximized_focus_active.png"

--theme.wallpaper                                 = '/home/alen/Pictures/wallpapers/cyberpunk.jpg'
theme.wallpaper_folder                          = '/home/alen/Pictures/wallpapers/'

-- You can use your own layout icons like this:
theme.layout_fairh                              = themes_path .. "default/layouts/fairhw.png"
theme.layout_fairv                              = themes_path .. "default/layouts/fairvw.png"
theme.layout_floating                           = themes_path .. "default/layouts/floatingw.png"
theme.layout_magnifier                          = themes_path .. "default/layouts/magnifierw.png"
theme.layout_max                                = themes_path .. "default/layouts/maxw.png"
theme.layout_fullscreen                         = themes_path .. "default/layouts/fullscreenw.png"
theme.layout_tilebottom                         = themes_path .. "default/layouts/tilebottomw.png"
theme.layout_tileleft                           = themes_path .. "default/layouts/tileleftw.png"
theme.layout_tile                               = themes_path .. "default/layouts/tilew.png"
theme.layout_tiletop                            = themes_path .. "default/layouts/tiletopw.png"
theme.layout_spiral                             = themes_path .. "default/layouts/spiralw.png"
theme.layout_dwindle                            = themes_path .. "default/layouts/dwindlew.png"
theme.layout_cornernw                           = themes_path .. "default/layouts/cornernww.png"
theme.layout_cornerne                           = themes_path .. "default/layouts/cornernew.png"
theme.layout_cornersw                           = themes_path .. "default/layouts/cornersww.png"
theme.layout_cornerse                           = themes_path .. "default/layouts/cornersew.png"

-- Generate Awesome icon:
theme.awesome_icon                              = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme                                = 'furamono nerd font 11'
theme.iconfont                                  = "FiraCode Nerd Font"
theme.iconfont_big                              = "FiraCode Nerd Font 11"
theme.taglist_font                              = "FiraCode Nerd Font 13"
return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
