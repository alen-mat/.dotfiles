#!/usr/bin/env bash

# Add this script to your wm startup file.

DIR="$HOME/.config/polybar/swifty"

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch the bar
polybar -c "$DIR"/config control &
polybar -c "$DIR"/config workspace &
pgrep spotify && polybar -c "$DIR"/config player &
polybar -c "$DIR"/config status &
polybar -c "$DIR"/config power &
