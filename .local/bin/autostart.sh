#!/usr/bin/env sh
nitrogen --restore &
mpd &
picom &
[[ $1 = "bar" ]] && ~/.config/polybar/sleek/launch.sh 

deviceid=$(xinput list | grep "Touchpad" | awk '{print $5}'|cut -d= -f2)
if [[ ${deviceid-} ]];then
xinput set-prop $deviceid "libinput Middle Emulation Enabled" 1
xinput set-prop $deviceid "libinput Tapping Enabled" 1
fi

parcellite &
emacs --bg-daemon &
#bluetooth 
flameshot &
pactl load-module module-bluetooth-discover
~/.local/bin/update-check-job.sh&
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
[[ -f ~/.cache/wal/colors.Xresources ]] && xrdb -merge ~/.cache/wal/colors.Xresources
bash -c "sleep 5; conky"
