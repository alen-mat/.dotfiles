#!/usr/bin/env bash
if [[ ! -f /tmp/autostart_done ]]
then
    if [ -x "$(command -v picom)" ]; then
        pgrep picom || picom -f --vsync --dbus --experimental-backend --config ~/.config/picom/picom  -b&
    else
        pgrep compton ||compton -f --config ~/.config/compton.conf -b 
    fi

    _ps=(ksuperkey mpd xfce-polkit xfce4-power-manager poweralertd polkit-dumb-agent)
    for _prs in "${_ps[@]}"; do
	if [[ $(pidof ${_prs}) ]]; then
		killall -9 ${_prs}
	fi
    done

    xsetroot -cursor_name left_ptr &

    deviceid="$(xinput list | grep "Touchpad" | awk '{print $5}'|cut -d= -f2)"
    if [[ ${deviceid-} ]];then
	device_props=("libinput Middle Emulation Enabled" "libinput Tapping Enabled")
    	for i in  $(echo ${!device_props[@]}); do
	    xinput list-props $deviceid | grep -q "${device_props[$i]}" && xinput set-prop $deviceid "${device_props[$i]}" 1
    	done
    fi

    if [[ $(command -v setxkbmap >/dev/null 2>&1) ]] ;then
	setxkbmap -option ctrl:nocaps
	xmodmap -e "keycode 9 = Caps_Lock NoSymbol Caps_Lock"
	setxkbmap -option caps:swapescape
	xmodmap -e "keycode 66 = Escape NoSymbol Escape"
    fi
    if [[ $(command -v xcape >/dev/null 2>&1) ]]; then 
	xcape -e 'Control_L=Escape'
	xcape -e '#66=Escape'
    fi
	
    command -v lxqt-policykit-agent >/dev/null 2>&1 && lxqt-policykit-agent&
    #bluetooth
    command -v blueman-applet >/dev/null 2>&1 && blueman-applet&
    command -v nm-applet >/dev/null 2>&1 && nm-applet&
    command -v ulauncher >/dev/null 2>&1 && ulauncher&
    command -v touchegg >/dev/null 2>&1 && touchegg&
    command -v mpd >/dev/null 2>&1 && exec mpd &

    pactl load-module module-bluetooth-discover

    #[[ -f /usr/lib/xfce-polkit/xfce-polkit ]] && /usr/lib/xfce-polkit/xfce-polkit &
    command -v polkit-dumb-agent >/dev/null 2>&1 && polkit-dumb-agent&
    #command -v xfce4-power-manager >/dev/null 2>&1 && xfce4-power-manager &
    command -v poweralertd >/dev/null 2>&1 && poweralertd&
 
    [[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
    [[ -f ~/.cache/wal/colors.Xresources ]] && xrdb -merge ~/.cache/wal/colors.Xresources

    systemctl start --user greenclip.service&
    ~/.fehbg &
    touch /tmp/autostart_done
    notify-send "WM" "Auto Start Complete"
fi
