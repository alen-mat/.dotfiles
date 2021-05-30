#DIR=`pwd`

DIR="$HOME/.config/polybar/basic-theme"

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch the bar
#polybar -r -q top -c "$DIR"/config.ini &
#polybar -r -q bottom -c "$DIR"/config.ini &

echo "-----Top Bar-----" | tee -a /tmp/top-bar-poly.log
# echo "---Bottom Bar---" | tee -a /tmp/bottom-bar-poly.log

if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar -l info -q top -c "$DIR"/config.ini & #-r 2>&1 | cat >> /tmp/top-bar-poly.log & disown
  done
else
 polybar -l info -q top -c "$DIR"/config.ini &#-r 2>&1 | cat >> /tmp/top-bar-poly.log & disown
 #polybar --reload example &
fi
#debugging polybar
#polybar -l info -q top -c "$DIR"/config.ini -r 2>&1 | cat >> /tmp/top-bar-poly.log & disown

#nohup polybar -l info -q bottom -c "$DIR"/config.ini -r > /tmp/bottom-bar-poly.log & 

#polybar bar2 2>&1 | tee -a /tmp/polybar2.log & disown

echo "Bars launched..."
