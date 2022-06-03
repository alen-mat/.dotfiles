#!/usr/bin/env sh


DIR="$HOME/.config/polybar/color"

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 0.1; done

# Host-dependent settings
export ETH_INTERFACE=etho
export WIFI_INTERFACE=wlp3s0
export TEMPERATURE_HWMON_PATH=/sys/class/hwmon/hwmon4/temp1_input

# Launch bar1 and bar2
for m in $(xrandr --listmonitors | tail -n +2 | awk -e '{ print $4  }'); do
  MONITOR=$m polybar -q main -c "$DIR"/config &
done

echo "Polybar launched."
