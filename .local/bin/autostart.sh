#!/usr/bin/env sh
mpd &
picom &
[[ $1 = "bar" ]] && ~/.config/polybar/sleek/launch.sh 

deviceid=$(xinput list | grep "Touchpad" | awk '{print $5}'|cut -d= -f2)
if [[ ${deviceid-} ]];then
	device_props=("libinput Middle Emulation Enabled" "libinput Tapping Enabled")
	for i in ${!device_props[@]}; do
		xinput list-props $deviceid | grep -q $device_prop && xinput set-prop $deviceid ${!device_props[i]} 1
	done
fi

greenclip daemon
emacs --bg-daemon &
#bluetooth
#nm-applet 
pactl load-module module-bluetooth-discover
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
[[ -f ~/.cache/wal/colors.Xresources ]] && xrdb -merge ~/.cache/wal/colors.Xresources
#bash -c "sleep 5; conky"
