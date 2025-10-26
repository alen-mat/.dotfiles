local beautiful     = require("beautiful")
local hotkeys_popup = require("awful.hotkeys_popup")
local awful         = require("awful")
local env           = require("env")
local mymainmenu    = awful.menu({
    items = {
        { "awesome", {
            { "hotkeys", function()
                hotkeys_popup.show_help(nil, awful.screen.focused())
            end },
            { "manual",      env.terminal .. " -e man awesome" },
            { "restart",     awesome.restart },
            { "quit", function()
                awesome.quit()
            end },
        }, beautiful.awesome_icon },
        { "System", {
            { "Lock", function()
                awful.spawn.with_shell([[ i3lock -B 10 10 --screen 0  --clock]])
            end },
            { "Sleep", function()
                awful.spawn.with_shell("systemctl suspend")
            end },
            { "Reboot", function()
                awful.spawn.with_shell("systemctl reboot")
            end },
            { "Shutdown", function()
                awful.spawn.with_shell("systemctl poweroff")
            end },
        } },
    }
})
return mymainmenu
