#!/usr/bin/env bash
DISPLAY=:0
if [ -r ~/.local/share/Xdbus ]; then
  source ~/.local/share/Xdbus
fi
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
NOTIFY_ICON=~/.icons/Vimix/symbolic/status/software-update-available-symbolic.svg

UPDATES=$($dir/checkupdates 2>/dev/null | wc -l);
echo "${UPDATES}" > /tmp/pkg2update.txt
hash polybar-msg 2>/dev/null && polybar-msg hook pacman-packages 2

if hash notify-send &>/dev/null; then
    if (( $UPDATES > 50 )); then
        notify-send -u critical -i $NOTIFY_ICON \
            "You really need to update!!" "$UPDATES New packages"
    elif (( $UPDATES > 25 )); then
        notify-send -u normal -i $NOTIFY_ICON \
            "You should update soon" "$UPDATES New packages"
    elif (( $UPDATES > 2 )); then
        notify-send -u low -i $NOTIFY_ICON \
            "$UPDATES New packages"
    fi
fi

