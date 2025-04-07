local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

require("env")

local env = _G.env

require("component")
require("component.keys")

local naughty = require("naughty")

local battery_widget = require("monitor.power.dbus")
battery_widget:init()

-- Standard awesome library
require("awful.autofocus")
-- Widget and layout library
-- Declarative object management
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

local ss = require('widgets.screenshots')


-- This is used later as the default terminal and editor to run.
local terminal     = env.terminal
editor             = os.getenv("EDITOR") or "nano"
editor_cmd         = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
local modkey       = env.keys.mod
local altkey       = env.keys.alt
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
local mymainmenu   = awful.menu({
    items = {
        { "awesome", {
            { "hotkeys", function()
                hotkeys_popup.show_help(nil, awful.screen.focused())
            end },
            { "manual",      terminal .. " -e man awesome" },
            { "edit config", editor_cmd .. " " .. awesome.conffile },
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
            { "Shutdown", function()
                awful.spawn.with_shell("systemctl poweroff")
            end },
        } },
    }
})

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
menubar.utils.terminal  = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Tag layout
-- Table of layouts to cover with awful.layout.inc, order matters.
-- }}}

-- }}}

-- {{{ Wibar

-- Keyboard map indicator and switcher
mykeyboardlayout        = awful.widget.keyboardlayout()

-- Create a textclock widget
mytextclock             = wibox.widget.textclock()

local create_update_cb  = function(self, c, index, objects)
    local tb = self:get_children_by_id('text_role')[1]
    local set_markup_silently = tb.set_markup_silently
    tb.set_markup_silently = function(slf, text)
        local replace_by = c.class
        if c.class == "org.wezfurlong.wezterm" then
            replace_by = "wezterm"
        end
        local new_text = string.gsub(text, c.name, replace_by:upper())
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
    s.mypromptbox = awful.widget.prompt()
    s.battery = require("widgets.battery") {}
    s.pipewire = require("widgets.pipewire")
    s.pipewire:setup({})
    s.network = require("widgets.network")
    s.network:init()
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
            awful.button({}, 3, function() mymainmenu:toggle() end),
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

awful.keyboard.append_global_keybindings({
    awful.key({}, 'Print', function()
        ss.full_screen(true)
    end, { description = 'Save desktop screenshot to file', group = 'Screenshot' }),
    awful.key({ 'Control' }, 'Print', function()
        ss.full_screen(false)
    end, { description = 'Save desktop screenshot to clipboard', group = 'Screenshot' }),
    awful.key({ 'Control', 'Shift' }, 'Print', function()
        ss.selection(true)
    end, { description = 'Mark an area and screenshot it (clipboard)', group = 'Screenshot' }),
    awful.key({ 'Control', altkey }, 'Print', function()
        ss.aw(true)
    end, { description = 'Screenshot active window to clipboard', group = 'Screenshot' }),
    awful.key({ altkey }, 'Print', function()
        ss.aw(false)
    end, { description = 'Screenshot active window', group = 'Screenshot' }),
})

-- General Awesome keys
awful.keyboard.append_global_keybindings({
    -- awful.key({ modkey, "Control" }, "k", toggle_splash,
    --     { description = "splash term", group = "Utils" }),
    awful.key({ modkey, }, "s", hotkeys_popup.show_help,
        { description = "show help", group = "awesome" }),
    awful.key({ modkey, }, "w", function() mymainmenu:show() end,
        { description = "show main menu", group = "awesome" }),
    awful.key({ modkey }, "x",
        function()
            awful.prompt.run {
                prompt       = "Run Lua code: ",
                textbox      = awful.screen.focused().mypromptbox.widget,
                exe_callback = awful.util.eval,
                history_path = awful.util.get_cache_dir() .. "/history_eval"
            }
        end,
        { description = "lua execute prompt", group = "awesome" }),
    awful.key({ modkey, }, "Return", function() awful.spawn(terminal) end,
        { description = "open a terminal", group = "launcher" }),
    awful.key({ modkey }, "r", function() awful.screen.focused().mypromptbox:run() end,
        { description = "run prompt", group = "launcher" }),
    awful.key({ modkey }, "p", function() menubar.show() end,
        { description = "show the menubar", group = "launcher" }),
})

-- Tags related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey, }, "Left", awful.tag.viewprev,
        { description = "view previous", group = "tag" }),
    awful.key({ modkey, }, "Right", awful.tag.viewnext,
        { description = "view next", group = "tag" }),
    awful.key({ modkey, }, "Escape", awful.tag.history.restore,
        { description = "go back", group = "tag" }),
})

-- Focus related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey, }, "j",
        function()
            awful.client.focus.byidx(1)
        end,
        { description = "focus next by index", group = "client" }
    ),
    awful.key({ modkey, }, "k",
        function()
            awful.client.focus.byidx(-1)
        end,
        { description = "focus previous by index", group = "client" }
    ),
    awful.key({ modkey, }, "Tab",
        function()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        { description = "go back", group = "client" }),
    awful.key({ modkey, "Control" }, "j", function() awful.screen.focus_relative(1) end,
        { description = "focus the next screen", group = "screen" }),
    awful.key({ modkey, "Control" }, "k", function() awful.screen.focus_relative(-1) end,
        { description = "focus the previous screen", group = "screen" }),
    awful.key({ modkey, "Control" }, "n",
        function()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                c:activate { raise = true, context = "key.unminimize" }
            end
        end,
        { description = "restore minimized", group = "client" }),
})

-- Layout related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey, "Shift" }, "j", function() awful.client.swap.byidx(1) end,
        { description = "swap with next client by index", group = "client" }),
    awful.key({ modkey, "Shift" }, "k", function() awful.client.swap.byidx(-1) end,
        { description = "swap with previous client by index", group = "client" }),
    awful.key({ modkey, }, "u", awful.client.urgent.jumpto,
        { description = "jump to urgent client", group = "client" }),
    awful.key({ modkey, }, "l", function() awful.tag.incmwfact(0.05) end,
        { description = "increase master width factor", group = "layout" }),
    awful.key({ modkey, }, "h", function() awful.tag.incmwfact(-0.05) end,
        { description = "decrease master width factor", group = "layout" }),
    awful.key({ modkey, "Shift" }, "h", function() awful.tag.incnmaster(1, nil, true) end,
        { description = "increase the number of master clients", group = "layout" }),
    awful.key({ modkey, "Shift" }, "l", function() awful.tag.incnmaster(-1, nil, true) end,
        { description = "decrease the number of master clients", group = "layout" }),
    awful.key({ modkey, "Control" }, "h", function() awful.tag.incncol(1, nil, true) end,
        { description = "increase the number of columns", group = "layout" }),
    awful.key({ modkey, "Control" }, "l", function() awful.tag.incncol(-1, nil, true) end,
        { description = "decrease the number of columns", group = "layout" }),
    awful.key({ modkey, }, "space", function() awful.layout.inc(1) end,
        { description = "select next", group = "layout" }),
    awful.key({ modkey, "Shift" }, "space", function() awful.layout.inc(-1) end,
        { description = "select previous", group = "layout" }),
})



client.connect_signal("request::default_mousebindings", function()
    awful.mouse.append_client_mousebindings({
        awful.button({}, 1, function(c)
            c:activate { context = "mouse_click" }
        end),
        awful.button({ modkey }, 1, function(c)
            c:activate { context = "mouse_click", action = "mouse_move" }
        end),
        awful.button({ modkey }, 3, function(c)
            c:activate { context = "mouse_click", action = "mouse_resize" }
        end),
    })
end)

client.connect_signal("manage", function(c)
    if c.type == "dock"             -- Plasma Panel
        or c.type == "desktop" then -- Plasma Desktop
        c.focusable = false
        c:tags(c.screen.tags)       -- show on all tags from this screen.
    end

    -- Show titlebars only if enabled.
    if c.titlebars then
        awful.titlebar.show(c)
    else
        --awful.titlebar.hide(c)
    end

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
end)

client.connect_signal("request::default_keybindings", function()
    awful.keyboard.append_client_keybindings({
        awful.key({ modkey, }, "f",
            function(c)
                c.fullscreen = not c.fullscreen
                c:raise()
            end,
            { description = "toggle fullscreen", group = "client" }),
        awful.key({ modkey, }, "BackSpace", function(c) c:kill() end,
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
            { description = "(un)maximize horizontally", group = "client" }),
    })
end)

-- }}}

-- {{{ Rules
-- Rules to apply to new clients.
-- }}}

-- {{{ Titlebars
-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = {
        awful.button({}, 1, function()
            c:activate { context = "titlebar", action = "mouse_move" }
        end),
        awful.button({}, 3, function()
            c:activate { context = "titlebar", action = "mouse_resize" }
        end),
    }

    awful.titlebar(c).widget = {
        {
            {
                {
                    id     = "index_role",
                    widget = wibox.widget.textbox,
                },
                margins = 4,
                widget  = wibox.container.margin,
            },
            margins = 14,
            bg      = "#ff0000",
            shape   = gears.shape.rounded_rect,
            widget  = wibox.container.background,
        },
        {
            {
                margins = 14,
                bg      = "#ff0099",
                shape   = function(cr, width, height)
                    gears.shape.rounded_rect(cr, width, height / 2, 0)
                end,
                widget  = wibox.container.background,
            },
            widget = wibox.container.place,
        },
        layout = wibox.layout.flex.horizontal
    }
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
