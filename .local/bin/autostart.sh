nitrogen --restore &
mpd &
picom &
~/.config/polybar/sleek/launch.sh
parcellite &
emacs --bg-daemon &
#bluetooth 
flameshot &
pactl load-module module-bluetooth-discover
~/.local/bin/update-check-job.sh&
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
[[ -f ~/.cache/wal/colors.Xresources ]] && xrdb -merge ~/.cache/wal/colors.Xresources

