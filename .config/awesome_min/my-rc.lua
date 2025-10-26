local env = require("env")
env:init()

local mainmenu = require("component.menu")

local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
require("component")
require("component.keys").init()

local naughty = require("naughty")

local battery_widget = require("monitor.power.dbus")
battery_widget:init()
require("monitor.network.network")
local plyerctl_monitor = require("monitor.playerctl")
plyerctl_monitor:init()

-- Standard awesome library
require("awful.autofocus")
-- Widget and layout library
-- Declarative object management
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
--require("awful.hotkeys_popup.keys")


local modkey       = env.keys.mod
local altkey       = env.keys.alt
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
local layout_popup = awful.popup {
    widget       = wibox.widget {
        awful.widget.layoutlist {
            source          = awful.widget.layoutlist.source.default_layouts,
            base_layout     = wibox.widget {
                spacing         = dpi(5),
                forced_num_cols = 1,
                layout          = wibox.layout.grid.vertical,
            },
            widget_template = {
                {
                    {
                        {
                            id            = 'icon_role',
                            forced_height = dpi(31),
                            forced_width  = dpi(31),
                            widget        = wibox.widget.imagebox,
                        },
                        margins = 4,
                        widget  = wibox.container.margin,
                    },
                    {

                        id     = 'text_role',
                        widget = wibox.widget.textbox,
                    },
                    layout = wibox.layout.fixed.horizontal,
                },
                id              = 'background_role',
                forced_width    = dpi(125),
                forced_height   = dpi(32),
                shape           = gears.shape.rounded_rect,
                widget          = wibox.container.background,
                create_callback = function(self)
                    self:connect_signal("mouse::enter", function(c)
                        c:set_bg(beautiful.bg_focus)
                    end)
                    self:connect_signal("mouse::leave", function(c)
                        c:set_bg(beautiful.bg_normal)
                    end)
                end
            },
        },
        margins = dpi(10),
        widget  = wibox.container.margin,
    },
    border_color = beautiful.border_color,
    border_width = beautiful.border_width,
    ontop        = true,
    visible      = false
}
layout_popup:connect_signal("button::press",
    function()
        layout_popup.visible = false
    end
)

-- Menubar configuration
menubar.utils.terminal = env.terminal -- Set the terminal for applications that require it
-- }}}


-- {{{ Wibar

-- Keyboard map indicator and switcher
local mykeyboardlayout  = awful.widget.keyboardlayout()

-- Create a textclock widget
local mytextclock       = wibox.widget.textclock()

local create_update_cb  = function(self, c, index, objects)
    local tb = self:get_children_by_id('text_role')[1]
    local set_markup_silently = tb.set_markup_silently
    tb.set_markup_silently = function(slf, text)
        local replace_by = c.class
        if c.class == "org.wezfurlong.wezterm" then
            replace_by = "wezterm"
        end
        --local new_text = string.gsub(text, c.name, replace_by:upper())
        local new_text = replace_by:upper()
        if c.minimized then new_text = "-" .. new_text end
        return set_markup_silently(tb, new_text)
    end
end

local tasklist_template = {
    {
        nil,
        {
            {
                awful.widget.clienticon,
                id     = "icon_margin_role",
                left   = 4,
                widget = wibox.container.margin
            },
            {
                {
                    id     = "text_role",
                    widget = wibox.widget.textbox,
                },
                id     = "text_margin_role",
                left   = 4,
                right  = 4,
                widget = wibox.container.margin
            },
            --fill_space = true,
            layout = wibox.layout.fixed.horizontal
        },
        expand = "outside",
        layout = wibox.layout.align.horizontal,
    },
    id              = "background_role",
    widget          = wibox.container.background,

    create_callback = create_update_cb,
    update_callback = create_update_cb,
}
local layout            = {
    spacing_widget = {
        {
            forced_width  = 5,
            forced_height = 24,
            thickness     = 1,
            color         = "#777777",
            widget        = wibox.widget.separator
        },
        valign = "center",
        halign = "center",
        widget = wibox.container.place,
    },
    spacing        = 1,
    layout         = wibox.layout.fixed.horizontal
}
-- Notice that there is *NO* wibox.wibox prefix, it is a template,
-- not a widget instance.
local widget_template   = {
    {
        wibox.widget.base.make_widget(),
        forced_height = 5,
        id            = "background_role",
        widget        = wibox.container.background,
    },
    {
        awful.widget.clienticon,
        margins = 5,
        widget  = wibox.container.margin
    },
    nil,
    layout = wibox.layout.align.vertical,
}

screen.connect_signal("request::desktop_decoration", function(s)
    -- Each screen has its own tag table.
    if s == screen.primary then
        s.mypromptbox = awful.widget.prompt()
        s.battery = require("widgets.battery") {}
        s.pipewire = require("widgets.pipewire")
        s.pipewire:setup({})
        s.network = require("widgets.network")
        s.network:init()
    end
    -- s.network = require("widgets.network")

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox {
        screen  = s,
        buttons = {
            awful.button({}, 1, function()
                if layout_popup.visible then
                    layout_popup.visible = not layout_popup.visible
                else
                    layout_popup:move_next_to(mouse.current_widget_geometry)
                end
            end),
            awful.button({}, 3, function() mainmenu:toggle() end),
            awful.button({}, 4, function() awful.layout.inc(-1) end),
            awful.button({}, 5, function() awful.layout.inc(1) end),
        }
    }
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = {
            awful.button({}, 1, function(t) t:view_only() end),
            awful.button({ modkey }, 1, function(t)
                if client.focus then
                    client.focus:move_to_tag(t)
                end
            end),
            awful.button({}, 3, awful.tag.viewtoggle),
            awful.button({ modkey }, 3, function(t)
                if client.focus then
                    client.focus:toggle_tag(t)
                end
            end),
            awful.button({}, 4, function(t) awful.tag.viewprev(t.screen) end),
            awful.button({}, 5, function(t) awful.tag.viewnext(t.screen) end),
        }
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen          = s,
        filter          = awful.widget.tasklist.filter.currenttags,
        layout          = layout,
        widget_template = tasklist_template,
        buttons         = {
            awful.button({}, 1, function(c)
                c:activate { context = "tasklist", action = "toggle_minimization" }
            end),
            awful.button({}, 3, function() awful.menu.client_list { theme = { width = 250 } } end),
            awful.button({}, 4, function() awful.client.focus.byidx(-1) end),
            awful.button({}, 5, function() awful.client.focus.byidx(1) end),
        },
    }

    -- Create the wibox
    s.mywibox = awful.wibar {
        position = "top",
        screen   = s,
        widget   = {
            layout = wibox.layout.align.horizontal,
            expand = "none",
            { -- Left widgets
                layout = wibox.layout.fixed.horizontal,
                s.mylayoutbox,
                s.mytaglist,
                s.mypromptbox,
            },
            s.mytasklist, -- Middle widget
            {             -- Right widgets
                layout = wibox.layout.fixed.horizontal,
                wibox.widget {
                    {
                        wibox.widget.systray(),
                        widget = wibox.container.margin,
                    },
                    shape      = gears.shape.rounded_rect,
                    shape_clip = true,
                    widget     = wibox.container.background,
                },
                wibox.widget {
                    widget = wibox.widget.separator,
                    orientation = "vertical",
                    forced_width = 10,
                    color = "#ffffff",
                    visible = true
                },
                s.network.widget,
                s.pipewire.volume_widget,
                s.battery,
                mykeyboardlayout,
                mytextclock,
            },
        }
    }
end)

-- }}}

-- {{{ Mouse bindings
awful.mouse.append_global_mousebindings({
    awful.button({}, 3, function() mymainmenu:toggle() end),
    awful.button({}, 4, awful.tag.viewprev),
    awful.button({}, 5, awful.tag.viewnext),
})
-- }}}

-- {{{ Key bindings

client.connect_signal("manage", function(c)
    if c.type == "dock"             -- Plasma Panel
        or c.type == "desktop" then -- Plasma Desktop
        c.focusable = false
        c:tags(c.screen.tags)       -- show on all tags from this screen.
    end

    -- Show titlebars only if enabled.

    -- Place floating windows. Plasma widgets provide this info
    if c.floating then
        if c.size_hints.user_position then
            c.x = c.size_hints.user_position.x
            c.y = c.size_hints.user_position.y
        end
        if c.size_hints.user_size then
            c.width = c.size_hints.user_size.width
            c.height = c.size_hints.user_size.height
        end
    end

    -- local s = awful.screen.focused()
    -- c.x, c.y = s.geometry.x, s.geometry.y
    if c.fullscreen then
        c:geometry(c.screen.geometry)
    end
end)

client.connect_signal("fullscreen", function(c)
    if c.fullscreen then
        gears.timer.delayed_call(function()
            if c.valid then
                c:geometry(c.screen.geometry)
            end
        end)
    end
end)

-- {{{ Titlebars
-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = {
        awful.button({}, 1, function()
            c:activate { context = "titlebar", action = "mouse_move" }
        end),
        awful.button({}, 3, function()
            c:activate { action = "mouse_resize", context = "titlebar" }
        end),
    }

    local wid = wibox.widget.base.make_widget()

    function wid:draw(context, cr, width, height)
        local w1 = width - math.floor(width / 1.9)
        local w2 = width - math.floor(width / 1.2)
        cr:set_source(gears.color(beautiful.monnet.color6))
        cr:rectangle(dpi(6), dpi(4), dpi(w1), dpi(6))
        cr:rectangle(dpi(w1) + dpi(10), dpi(4), dpi(w2 - w1) - dpi(14), dpi(6))
        cr:rectangle(dpi(w2), dpi(4), dpi(width - w2) - dpi(6), dpi(6))
        cr:fill()
    end

    local at = awful.titlebar(c, { size = beautiful.title_bar_size })
    at.widget = wid
end)

client.connect_signal("mouse::enter", function(c)
    c:activate { context = "mouse_enter", raise = false }
end)


client.connect_signal("focus", function(c)
    --flashfocus(c)
    c.border_color = beautiful.border_focus
    c.opacity = 1
end)
--client.disconnect_signal("focus", flashfocus)

client.connect_signal("unfocus", function(c)
    c.border_color = beautiful.border_normal
    c.opacity = 0.85
end)
gears.timer {
    timeout = 30,
    autostart = true,
    callback = function() collectgarbage() end
}

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
