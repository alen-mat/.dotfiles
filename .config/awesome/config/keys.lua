local gears = require("gears")
local hotkeys_popup = require("awful.hotkeys_popup")
local menubar = require("menubar")
local awful = require("awful")
local mykeyboardlayout = awful.widget.keyboardlayout()
local ss = require('utils.screenshots')

local keys = gears.table.join(
    awful.key({ modkey, }, "F1", hotkeys_popup.show_help,
        { description = "show help", group = "awesome" }),
    awful.key({ modkey, }, "Left", awful.tag.viewprev,
        { description = "view previous", group = "tag" }),
    awful.key({ modkey, }, "Right", awful.tag.viewnext,
        { description = "view next", group = "tag" }),
    awful.key({ modkey, }, "Escape", awful.tag.history.restore,
        { description = "go back", group = "tag" }),

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
    awful.key({ modkey, }, "w", function() mymainmenu:show() end,
        { description = "show main menu", group = "awesome" }),

    -- Layout manipulation
    awful.key({ modkey, "Shift" }, "j", function() awful.client.swap.byidx(1) end,
        { description = "swap with next client by index", group = "client" }),
    awful.key({ modkey, "Shift" }, "k", function() awful.client.swap.byidx(-1) end,
        { description = "swap with previous client by index", group = "client" }),
    awful.key({ modkey, "Control" }, "j", function() awful.screen.focus_relative(1) end,
        { description = "focus the next screen", group = "screen" }),
    awful.key({ modkey, "Control" }, "k", function() awful.screen.focus_relative(-1) end,
        { description = "focus the previous screen", group = "screen" }),
    awful.key({ modkey, }, "u", awful.client.urgent.jumpto,
        { description = "jump to urgent client", group = "client" }),
    --awful.key({ modkey, }, "Tab",
    --    function()
    --        awful.client.focus.history.previous()
    --        if client.focus then
    --            client.focus:raise()
    --        end
    --    end,
    --    { description = "go back", group = "client" }),

    -- Standard program
    awful.key({ modkey, }, "Return", function() awful.spawn(terminal) end,
        { description = "open a terminal", group = "launcher" }),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
        { description = "reload awesome", group = "awesome" }),
    awful.key({ modkey, "Shift" }, "q", awesome.quit,
        { description = "quit awesome", group = "awesome" }),
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

    awful.key({ modkey, "Control" }, "n",
        function()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                c:emit_signal(
                    "request::activate", "key.unminimize", { raise = true }
                )
            end
        end,
        { description = "restore minimized", group = "client" }),

    -- Prompt
    awful.key({ modkey }, "r", function() awful.screen.focused().mypromptbox:run() end,
        { description = "run prompt", group = "launcher" }),

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
    -- Menubar
    awful.key({ modkey }, "o", function() menubar.show() end,
        { description = "show the menubar", group = "launcher" }),
    awful.key({ "Shift" }, "Alt_L", function() mykeyboardlayout.next_layout(); end,
        { description = 'Next Keyboard Layout', group = 'util' }),
    awful.key({ "Mod1" }, "Shift_L", function() mykeyboardlayout.next_layout(); end,
        { description = 'Next Keyboard Layout', group = 'util' }),

    awful.key({}, "XF86AudioRaiseVolume", function()
        awful.spawn('pactl set-sink-volume @DEFAULT_SINK@ +3%', false)
    end, { description = 'Increase Volume', group = 'Audio' }),
    awful.key({}, "XF86AudioLowerVolume", function()
        awful.spawn('pactl set-sink-volume @DEFAULT_SINK@ -2%', false)
    end, { description = 'Decrease Volume', group = 'Audio' }),
    awful.key({}, "XF86AudioMute", function()
        awful.spawn('pactl set-sink-mute @DEFAULT_SINK@ toggle', false)
    end, { description = 'Mute', group = 'Audio' }),
    awful.key({}, "XF86AudioMicMute", function()
        awful.spawn('pactl set-source-mute @DEFAULT_SOURCE@ toggle', false)
    end, { description = 'Mute Mic', group = 'Audio' }),

    awful.key({}, "XF86MonBrightnessUp", function()
        awful.spawn('brightnessctl set 3%+', false)
    end, { description = 'Increase screen brightness', group = 'Backlight' }),
    awful.key({}, "XF86MonBrightnessDown", function()
        awful.spawn('brightnessctl set 2%-', false)
    end, { description = 'Decrease screen brightness', group = 'Backlight' }),
    awful.key({ modkey }, "XF86MonBrightnessUp", function()
        awful.spawn.with_shell('$HOME/.local/bin/msi-mystic -T', false)
    end, { description = 'Toggle keyboard Backlight', group = 'Backlight' }),
    awful.key({ modkey }, "XF86MonBrightnessDown", function()
        awful.spawn.with_shell('$HOME/.local/bin/msi-mystic -T', false)
    end, { description = 'Toggle keyboard Backlight', group = 'Backlight' }),

    awful.key({}, "XF86AudioPlay", function()
        awful.spawn('playerctl play-pause', false)
    end, { description = 'Play / Pause', group = 'Media' }),
    awful.key({}, "XF86AudioStop", function()
        awful.spawn('playerctl stop', false)
    end, { description = 'Stop', group = 'Media' }),
    awful.key({}, "XF86AudioNext", function()
        awful.spawn('playerctl next', false)
    end, { description = 'Next', group = 'Media' }),
    awful.key({}, "XF86AudioPrev", function()
        awful.spawn('playerctl previous', false)
    end, { description = 'Previous', group = 'Media' }),
    awful.key({ modkey }, "XF86AudioRaiseVolume", function()
        awful.spawn('playerctl volume 0.008+', false)
    end, { description = 'Increase Volume of active player', group = 'Media' }),
    awful.key({ modkey }, "XF86AudioLowerVolume", function()
        awful.spawn('playerctl volume 0.005-', false)
    end, { description = 'Decrease Volume of active player', group = 'Media' }),
    awful.key({}, "XF86TouchpadToggle", function()
        awful.spawn.with_shell('$HOME/.scripts/toggle_touchpad', false)
    end, { description = 'Toggle Touchpad', group = 'Devices' }),
    awful.key({}, "XF86Tools", function()
        awful.spawn.with_shell('$HOME/.scripts/toggle_touchpad', false)
    end, { description = 'Toggle Touchpad', group = 'Devices' }),
    awful.key({}, "XF86WebCam", function()
        awful.spawn.with_shell('$HOME/.scripts/toggle_touchpad', false)
    end, { description = 'Toggle Touchpad', group = 'Devices' }),

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
    awful.key({ modkey, altkey }, 'i', function()
        awful.util.spawn_with_shell('~/.scripts/invert-window')
    end, { description = 'Compton invert window', group = 'Util' }),

    awful.key({ modkey, altkey }, 'l', function()
        awful.util.spawn_with_shell(' ~/.scripts/lock/lock-run', false)
    end, { description = 'Lock', group = 'Util' }),

    awful.key({ modkey }, "e", function()
        awful.spawn('alacritty --class "float" -e "/usr/bin/vifm"', false)
    end, { description = 'Vifm', group = 'Util' })

)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    keys = gears.table.join(keys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    tag:view_only()
                end
            end,
            { description = "view tag #" .. i, group = "tag" }),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            { description = "toggle tag #" .. i, group = "tag" }),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            { description = "move focused client to tag #" .. i, group = "tag" }),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
            { description = "toggle focused client on tag #" .. i, group = "tag" })
    )
end

return keys
