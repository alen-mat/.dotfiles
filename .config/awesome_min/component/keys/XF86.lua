local awful = require("awful")
local modkey = _G.env.keys.mod
local pipewire = require("widgets.pipewire")

awful.keyboard.append_global_keybindings({
    awful.key({}, "XF86AudioRaiseVolume", function()
        pipewire:inc_volume()
    end, { description = 'Increase Volume', group = 'Audio' }),
    awful.key({}, "XF86AudioLowerVolume", function()
        pipewire:dec_volume()
    end, { description = 'Decrease Volume', group = 'Audio' }),
    awful.key({}, "XF86AudioMute", function()
        pipewire:mute_defaut_sink()
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
        awful.spawn('playerctl volume 0.1+', false)
    end, { description = 'Increase Volume of active player', group = 'Media' }),
    awful.key({ modkey }, "XF86AudioLowerVolume", function()
        awful.spawn('playerctl volume 0.05-', false)
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
})
