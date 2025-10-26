--Docs
--https://awesomewm.org/apidoc/popups_and_bars/naughty.layout.box.html
--https://awesomewm.org/apidoc/declarative_rules/ruled.notifications.html
--https://awesomewm.org/apidoc/libraries/naughty.html#request::display

local naughty = require("naughty")
local beautiful = require("beautiful")
local gears = require("gears")
local awful = require("awful")
local ruled = require("ruled")
local dpi = beautiful.xresources.apply_dpi
local menubar = require('menubar')
local cst = require("naughty.constants")
local wibox = require("wibox")

-- Apply theme variables
naughty.config.padding = dpi(8)
naughty.config.spacing = dpi(8)
naughty.config.icon_dirs = {
    '/usr/share/icons/Tela',
    '/usr/share/icons/Tela-blue-dark',
    '/usr/share/icons/Papirus/',
    '/usr/share/icons/la-capitaine-icon-theme/',
    '/usr/share/icons/gnome/',
    '/usr/share/icons/hicolor/',
    '/usr/share/pixmaps/'
}
naughty.config.icon_formats = { 'svg', 'png', 'jpg', 'gif' }

naughty.config.defaults.ontop = true
naughty.config.defaults.icon_size = dpi(32)
naughty.config.defaults.screen = awful.screen.focused()
naughty.config.defaults.timeout = 3
naughty.config.defaults.title = "System Notification"
naughty.config.defaults.margin = dpi(16)
naughty.config.defaults.border_width = 0
naughty.config.defaults.position = "top_right"
naughty.config.defaults.shape = function(cr, w, h)
    gears.shape.rounded_rect(cr, w, h, dpi(12))
end

naughty.config.presets.low.timeout = 3
naughty.config.presets.critical.timeout = 0

naughty.config.presets.normal = {
    font = beautiful.title_font,
    fg = beautiful.fg_normal,
    bg = beautiful.bg_normal,
    position = "top_right",
    shape = naughty.config.defaults.shape
}

naughty.config.presets.low = {
    font = beautiful.title_font,
    fg = beautiful.fg_normal,
    bg = beautiful.bg_normal,
    position = "top_right",
    shape = naughty.config.defaults.shape
}

naughty.config.presets.critical = {
    font = "SF Display Bold 10",
    fg = "#ffffff",
    bg = "#ff0000",
    position = "top_right",
    timeout = 0,
    shape = naughty.config.defaults.shape
}

--function naughty.config.defaults.callback(_, appname)
--    awful.spawn("/bin/paplay  /home/alen/.local/share/audio/current")
--endno

naughty.config.presets.ok = naughty.config.presets.normal
naughty.config.presets.info = naughty.config.presets.normal
naughty.config.presets.warn = naughty.config.presets.critical


local function play_sound(n)
	if n.category == "device.added" or n.category == "network.connected" then
		awful.spawn("canberra-gtk-play -i service-login", false)
	elseif n.category == "device.removed" or n.category == "network.disconnected" then
		awful.spawn("canberra-gtk-play -i service-logout", false)
	elseif
		n.category == "device.error"
		or n.category == "im.error"
		or n.category == "network.error"
		or n.category == "transfer.error"
	then
		awful.spawn("canberra-gtk-play -i dialog-warning", false)
	elseif n.appname == "WhatsApp" or n.category == "email.arrived" then
		awful.spawn("canberra-gtk-play -i message", false)
	elseif n.category ~= "silent-notification" then
		awful.spawn("canberra-gtk-play -i bell", false)
	end
end

if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors
    })
end

-- overright notification draw
naughty.connect_signal(
    "request::display", function(notification, args)
        -- if notification.app_name == "Spotify" then
        -- end

        -- naughty.layout.box {
        --     notification = notification,
        --     ontop = true,
        --     icon_size = dpi(32),
        --     screen = awful.screen.focused(),
        --     timeout = 3,
        --     margin = dpi(16),
        --     border_width = 0,
        --     shape = function(cr, w, h)
        --         gears.shape.rounded_rect(cr, w, h, dpi(12))
        --     end
        -- }
        naughty.layout.box { notification = notification }
    end)

naughty.connect_signal(
    "invoked",
    function(_, action)
        if action.program == "Spotify" then
            if action.id == "skip-prev" then
                awful.spawn("playerctl previous")
            end
            if action.id == "play-pause" then
                awful.spawn("playerctl play-pause")
            end
            if action.id == "skip-next" then
                awful.spawn("playerctl next")
            end
        end
    end
)

ruled.notification.connect_signal('request::rules', function()
    ruled.notification.append_rule {
        rule       = {},
        properties = {
            screen           = awful.screen.preferred,
            implicit_timeout = 5,
        }
    }
    ruled.notification.append_rule {
        rule       = { urgency = "critical" },
        properties = { bg = "#ff0000", fg = "#ffffff", timeout = 0 }
    }

    -- -- Or green background for normal ones.
    -- ruled.notification.append_rule {
    --     rule       = { urgency = "normal" },
    --     properties = { bg = "#00ff00", fg = "#000000" }
    -- }

    ruled.notification.append_rule {
        rule       = { app_name = "Spotify" },
        properties = {
            widget_template = {
                {
                    {
                        {
                            {
                                naughty.widget.icon,
                                forced_height = 48,
                                halign        = "center",
                                valign        = "center",
                                widget        = wibox.container.place
                            },
                            {
                                halign = "center",
                                widget = naughty.widget.title,
                            },
                            {
                                halign = "center",
                                widget = naughty.widget.message,
                            },
                            {
                                orientation   = "horizontal",
                                widget        = wibox.widget.separator,
                                forced_height = 1,
                            },
                            {
                                nil,
                                {
                                    naughty.list.actions,
                                    spacing = 20,
                                    layout  = wibox.layout.fixed.horizontal,
                                },
                                expand = "outside",
                                nil,
                                layout = wibox.layout.align.horizontal,
                            },
                            spacing = 10,
                            layout  = wibox.layout.fixed.vertical,
                        },
                        margins = beautiful.notification_margin,
                        widget  = wibox.container.margin,
                    },
                    id     = "background_role",
                    widget = naughty.container.background,
                },
                strategy = "max",
                width    = 160,
                widget   = wibox.container.constraint,
            },
            append_actions = {
                --" ⏪
                --"⏸
                --"⏩
                naughty.action {
                    program = "Spotify",
                    id = "skip-prev",
                    name = "Previous",
                    icon = gears.color.recolor_image(beautiful.player_prev, beautiful.fg_normal)
                },
                naughty.action {
                    program = "Spotify",
                    id = "play-pause",
                    name = "Pause",
                    icon = gears.color.recolor_image(beautiful.player_play, beautiful.fg_normal)
                },
                naughty.action {
                    program = "Spotify",
                    id = "skip-next",
                    name = "Next",
                    icon = gears.color.recolor_image(beautiful.player_next, beautiful.fg_normal)
                }
            }

        }
    }
end)


naughty.connect_signal(
    'request::icon',
    function(n, context, hints)
        if context ~= 'app_icon' then return end

        local path = menubar.utils.lookup_icon(hints.app_icon) or
            menubar.utils.lookup_icon(hints.app_icon:lower())

        if path then
            n.icon = path
        end
    end
)
naughty.config.notify_callback = function(args)
    args.run = function(n)
        if n.clients then
            n.clients[1]:jump_to(false)
        end
        n.die(naughty.notificationClosedReason.dismissedByUser)
    end
    play_sound(args)
    return args
end

naughty.connect_signal("destroyed", function(n, reason)
    if not n.clients then
        return
    end
    if reason == cst.notification_closed_reason.dismissed_by_user then
        -- If we clicked on a notification, we get a new urgent client to jump to
        client.connect_signal("property::urgent", function(c)
            -- We don't use notification_client because it's not reliable (Ex: If we have two different instances of chrome)
            -- cf: https://awesomewm.org/apidoc/core_components/naughty.notification.html#clients
            -- So we just check if the client name of our notification is the same as the last urgent client
            -- and jump to this one.
            for _, notification_client in ipairs(n.clients) do
                if c.name == notification_client.name then
                    c:jump_to()
                end
            end
        end)
    end
end)
-------------oooooooooooooooooooooooooooooooooooooooooooo----------------
do
    local in_error = false
    awesome.connect_signal(
        "debug::error",
        function(err)
            if in_error then
                return
            end
            in_error = true

            naughty.notify({
                preset = naughty.config.presets.critical,
                title = "Oops, an error happened!",
                text = tostring(err)
            })
            in_error = false
        end
    )
end
