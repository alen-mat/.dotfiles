#!/usr/bin/env sh
nitrogen --restore &
mpd &
picom &
[[ $1 = "bar" ]] && ~/.config/polybar/sleek/launch.sh 
parcellite &
emacs --bg-daemon &
#bluetooth 
flameshot &
pactl load-module module-bluetooth-discover
~/.local/bin/update-check-job.sh&
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
[[ -f ~/.cache/wal/colors.Xresources ]] && xrdb -merge ~/.cache/wal/colors.Xresources
bash -c "sleep 5; conky"
