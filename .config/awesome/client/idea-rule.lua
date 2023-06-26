local awful = require("awful")
local gears = require("gears")

local clientbuttons_jetbrains = gears.table.join(
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize)
)


return  {
    {
        rule = {
            class = "jetbrains-.*",
        },
        properties = { focus = true, buttons = clientbuttons_jetbrains }
    },
    {
        rule = {
            class = "jetbrains-.*",
            name = "win.*"
        },
        properties = { titlebars_enabled = false, focusable = false, focus = true, floating = true,
            placement = awful.placement.restore }
    },
}
