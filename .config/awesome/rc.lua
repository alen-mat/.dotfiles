-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")
require('config.env')
local root = root
local screen = screen
-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
require('config.notifications')
-- Theme handling library
local beautiful = require("beautiful")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

require('utils.autorun')



-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
--beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
user_home = os.getenv('HOME')
theme_dir = user_home .. '/.config/awesome/themes/' .. 'default' .. '/'
--beautiful.init(theme_dir .. "theme.lua")

beautiful.init(require("themes.default"))

-- This is used later as the default terminal and editor to run.
terminal = "alacritty"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
altkey = "Mod1"
shiftkey = "Shift"
ctrlkey = "Control"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
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
    awful.layout.suit.magnifier,
    awful.layout.suit.corner.nw,
    awful.layout.suit.floating,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

local function set_wallpaper(s)
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, false)
    end
    if beautiful.wallpaper_color then
        gears.wallpaper.set(beautiful.wallpaper_color)
    end
    if beautiful.wallpaper_folder then
        local f = io.popen("sh -c \"find " ..
        beautiful.wallpaper_folder .. " -name '*.png' | shuf -n 1 | xargs echo -n\"")
        if f == nil then
            return
        end
        local wallpaper = f:read("*all")
        f:close()
        gears.wallpaper.maximized(wallpaper, s, false)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])
    -- Wallpaper
    set_wallpaper(s)

    require('bars')(s)
end)
-- }}}
-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({}, 3, function() end),
    awful.button({}, 4, awful.tag.viewnext),
    awful.button({}, 5, awful.tag.viewprev)
))
-- }}}

root.keys(require('config.keys'))


require('client.rules')
require('client.signals')

require('daemons.battery')
require('daemons.network')



gears.timer {
    timeout = 30,
    autostart = true,
    callback = function() collectgarbage() end
}
