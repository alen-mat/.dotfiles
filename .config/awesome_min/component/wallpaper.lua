local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local wallpaper = _G.env.wallpaper -- or beautiful.wallpaper
local gears = require("gears")

screen.connect_signal("request::wallpaper", function(s)
    awful.wallpaper {
        screen = s,
        widget = {
            {
                image     = wallpaper,
                upscale   = true,
                downscale = true,
                widget    = wibox.widget.imagebox,
            },
            valign = "center",
            halign = "center",
            tiled  = false,
            widget = wibox.container.tile,
        }
    }
end)


screen.connect_signal("property::geometry",function (s)
        gears.wallpaper.maximized(wallpaper, s, false)
end)
