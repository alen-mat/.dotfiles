local gears = require("gears")
local awful = require("awful")

local clientkeys = gears.table.join(
    awful.key({ modkey, }, "f",
        function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        { description = "toggle fullscreen", group = "client" }),
    awful.key({ modkey, "Shift" }, "f",
        function(c)
            c.floating = not c.floating
            if c.floating then
                local geo = {}
                geo.x = screen[1].geometry.x
                geo.y = screen[1].geometry.y
                geo.width = screen[1].geometry.width
                geo.height = screen[1].geometry.height
                geo.x2 = geo.x + geo.width
                geo.y2 = geo.y + geo.height
                for s in screen do
                    local geo2 = s.geometry
                    geo.x = math.min(geo.x, geo2.x)
                    geo.y = math.min(geo.y, geo2.y)
                    geo.x2 = math.max(geo.x2, geo2.x + geo2.width)
                    geo.y2 = math.max(geo.y2, geo2.y + geo2.height)
                end
                c:geometry {
                    x = geo.x,
                    y = geo.y,
                    width = geo.x2 - geo.x,
                    height = geo.y2 - geo.y
                }
            end
        end,
        { description = "multi-monitor fullscreen", group = 'client' }),
    awful.key({ modkey }, "BackSpace", function(c) c:kill() end,
        { description = "close", group = "client" }),
    awful.key({ modkey, "Control" }, "space", awful.client.floating.toggle,
        { description = "toggle floating", group = "client" }),
    awful.key({ modkey, "Control" }, "Return", function(c) c:swap(awful.client.getmaster()) end,
        { description = "move to master", group = "client" }),
    awful.key({ modkey, }, "o", function(c) c:move_to_screen() end,
        { description = "move to screen", group = "client" }),
    awful.key({ modkey, }, "t", function(c) c.ontop = not c.ontop end,
        { description = "toggle keep on top", group = "client" }),
    awful.key({ modkey, }, "n",
        function(c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end,
        { description = "minimize", group = "client" }),
    awful.key({ modkey, }, "m",
        function(c)
            c.maximized = not c.maximized
            c:raise()
        end,
        { description = "(un)maximize", group = "client" }),
    awful.key({ modkey, "Control" }, "m",
        function(c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end,
        { description = "(un)maximize vertically", group = "client" }),
    awful.key({ modkey, "Shift" }, "m",
        function(c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end,
        { description = "(un)maximize horizontally", group = "client" })
)

return clientkeys
