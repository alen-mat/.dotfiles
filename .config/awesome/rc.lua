require('awful.autofocus')
local gears = require('gears')
local awful = require('awful')
local naughty = require('naughty')
local dpi = require('beautiful').xresources.apply_dpi
local beautiful = require('beautiful')

-- Theme
beautiful.init(require('theme'))

-- Layout
require('layout')

-- Init all modules
require('module.notifications')
require('module.auto-start')
require('module.decorate-client')
require('module.splash-terminal')

-- Setup all configurations
require('configuration.client')
require('configuration.tags')
_G.root.keys(require('configuration.keys.global'))

-- Signal function to execute when a new client appears.
_G.client.connect_signal('manage', function(c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    if not _G.awesome.startup then
        awful.client.setslave(c)
    end

    if _G.awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Move cursor to focused window
function Move_mouse_onto_focused_client()
    local c = _G.client.focus
    gears.timer({
        timeout = 0.1,
        autostart = true,
        single_shot = true,
        callback = function()
            if _G.mouse.object_under_pointer() ~= c then
                local geometry = c:geometry()
                local x = geometry.x + geometry.width / 2
                local y = geometry.y + geometry.height / 2
                _G.mouse.coords({
                    x = x,
                    y = y
                }, true)
            end
        end
    })
end

if beautiful.cursor_warp then
    _G.client.connect_signal("focus", Move_mouse_onto_focused_client)
    _G.client.connect_signal("swapped", Move_mouse_onto_focused_client)
end

-- Enable sloppy focus, so that focus follows mouse.
_G.client.connect_signal('mouse::enter', function(c)
    c:emit_signal('request::activate', 'mouse_enter', {
        raise = true
    })
end)

-- Make the focused window have a glowing border
_G.client.connect_signal('focus', function(c)
    c.border_color = beautiful.border_focus
end)
_G.client.connect_signal('unfocus', function(c)
    c.border_color = beautiful.border_normal
end)

if beautiful.title_bar then
    -- Enable smart borders (https://github.com/intrntbrn/smart_borders)
    require('module.smart-borders') {
        show_button_tooltips = true,
        border_width = dpi(16),
        rounded_corner = dpi(0),
        positions = {"bottom"},
        button_positions = {"bottom"},
        button_size = dpi(40),
        color_focus = beautiful.primary.hue_200,
        color_normal = beautiful.primary.hue_100
    }
end
