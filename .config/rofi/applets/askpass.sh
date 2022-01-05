#!/bin/sh
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

dir=$DIR/../styles

rofi_command="rofi -theme $dir/powermenu.rasi"

rofi -dmenu \
     -password \
     -i \
     -theme $dir/message.rasi \
     -no-fixed-num-lines \
     -p "Sudo : "
