local filesystem = require('gears.filesystem')
local beautiful = require('beautiful')

local with_dpi = require('beautiful').xresources.apply_dpi
local get_dpi = require('beautiful').xresources.get_dpi
local rofi_command = 'env /usr/bin/rofi -show drun -display-drun -run-command "/bin/bash -c -i \'shopt -s expand_aliases; {cmd}\'"'

return {
    -- List of apps to start by default on some actions
    default = {
        terminal = 'kitty',
        rofi = rofi_command,
        lock = 'better',
        splash = 'kitty -T SplashTerminal -o background_opacity=0.95',
        power_command = '~/.config/rofi/applets/powermenu.sh',
        browser = 'env firefox',
        editor = 'kitty',
        social = 'env discord',
        files = 'pcmanfm',
        power_manager = 'gnome-power-statistics'
    },
    -- List of commands to start once on start-up
    run_on_start_up = {
        '~/.config/awesome/configuration/awspawn',
        'compton',
        'nitrogen --restore',
        'blueman-tray'
    }
}

