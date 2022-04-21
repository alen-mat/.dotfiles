#!/usr/bin/env sh
picom -f --experimental-backend --config ~/.config/picom/picom  -b&

xsetroot -cursor_name left_ptr &

deviceid=$(xinput list | grep "Touchpad" | awk '{print $5}'|cut -d= -f2)
if [[ ${deviceid-} ]];then
	device_props=("libinput Middle Emulation Enabled" "libinput Tapping Enabled")
	for i in  $(echo ${!device_props[@]}); do
		xinput list-props $deviceid | grep -q "${device_props[$i]}" && xinput set-prop $deviceid "${device_props[$i]}" 1
	done
fi

#bluetooth
blueman-applet&
nm-applet&
pactl load-module module-bluetooth-discover
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
[[ -f ~/.cache/wal/colors.Xresources ]] && xrdb -merge ~/.cache/wal/colors.Xresources
#bash -c "sleep 5; conky"
systemctl start --user greenclip.service&
