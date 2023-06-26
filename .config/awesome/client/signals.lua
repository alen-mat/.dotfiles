local awesome = awesome
local client = client

local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")

local op = beautiful.flash_focus_start_opacity or 0.6
local stp = beautiful.flash_focus_step or 0.01


-- Toggle titlebar on or off depending on s. Creates titlebar if it doesn't exist
local function setTitlebar(client, s)
    if s then
        if client.titlebar == nil then
            client:emit_signal("request::titlebars", "rules", {})
        end
        awful.titlebar.show(client)
    else
        awful.titlebar.hide(client)
    end
end

---------------------------------------
--- This it is a blight module.....----
---------------------------------------
local function flashfocus(c)
    if c and #c.screen.clients > 1 then
        c.opacity = op
        local q = op
        local g = gears.timer({
            timeout = stp,
            call_now = false,
            autostart = true,
        })

        g:connect_signal("timeout", function()
            if not c.valid then
                return
            end
            if q >= 1 then
                c.opacity = 1
                g:stop()
            else
                c.opacity = q
                q = q + stp
            end
        end)
    end
end


-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
        and not c.size_hints.user_position
        and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end

    --    setTitlebar(c, c.floating or c.first_tag.layout == awful.layout.suit.floating)
end)

--client.connect_signal("property::floating", function(c)
    -- setTitlebar(c, c.floating)
--end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({}, 1, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.move(c)
        end),
        awful.button({}, 3, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c):setup {
        {
            -- Right
            {
                awful.titlebar.widget.floatingbutton(c),
                awful.titlebar.widget.stickybutton(c),
                awful.titlebar.widget.ontopbutton(c),
                layout = wibox.layout.fixed.horizontal()
            },
            layout = wibox.layout.flex.horizontal
        },
        {
            {
                {
                    awful.titlebar.widget.iconwidget(c),
                    layout = wibox.layout.flex.horizontal
                },
                {
                    widget = awful.titlebar.widget.titlewidget(c),
                    layout = wibox.layout.flex.horizontal
                },
                align  = "center",
                layout = wibox.layout.fixed.horizontal
            },
            buttons = buttons,
            align   = "center",
            layout  = wibox.layout.flex.horizontal
        },
        {
            {
                awful.titlebar.widget.minimizebutton(c),
                awful.titlebar.widget.maximizedbutton(c),
                awful.titlebar.widget.closebutton(c),
                layout = wibox.layout.fixed.horizontal()
            },
            layout = wibox.layout.flex.horizontal
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
--client.connect_signal("mouse::enter", function(c)
--    c:emit_signal("request::activate", "mouse_enter", { raise = false })
--end)

client.connect_signal("focus", function(c)
    --flashfocus(c)
    c.border_color = beautiful.border_focus
    c.opacity = 1
end)
--client.disconnect_signal("focus", flashfocus)

client.connect_signal("unfocus", function(c)
    c.border_color = beautiful.border_normal
    c.opacity = 0.7
end)
-- }}}
