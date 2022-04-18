local filesystem = require('gears.filesystem')
local beautiful = require('beautiful')

local with_dpi = require('beautiful').xresources.apply_dpi
local get_dpi = require('beautiful').xresources.get_dpi
local rofi_command = 'env /usr/bin/rofi -show drun -display-drun -run-command "/bin/bash -c -i \'shopt -s expand_aliases; {cmd}\'"'

return {
    -- List of apps to start by default on some actions
    default = {
        terminal = 'kitty',

        rofi = '~/.local/bin/rofi_helper -a',
        power_command = '~/.local/bin/rofi_helper -p',

        lock = 'better',
        splash = 'kitty -T SplashTerminal -o background_opacity=0.95',

				screenshot_file = '~/.local/bin/maim_helper screen',
        screenshot_clip = '~/.local/bin/maim_helper screen clip',
				region_screenshot = '~/.local/bin/maim_helper selection clip',
        active_window_screenshot = '~/.local/bin/maim_helper active_window clip',

        browser = 'env firefox',
        editor = 'kitty',
        social = 'env discord',
        files = 'pcmanfm',
        power_manager = 'gnome-power-statistics'
    },
    -- List of commands to start once on start-up
    run_on_start_up = {
        '~/.config/awesome/configuration/awspawn',
        '[[ -x "$(command -v compton)" ]] && compton -f ~/.config/compton.conf || picom -f --experimental-backend --config ~/.config/picom/picom  -b',
        'nitrogen --restore',
        'blueman-tray'
    }
}

