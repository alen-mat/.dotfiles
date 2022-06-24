#!/usr/bin/env bash

# Color files
PFILE="$HOME/.config/polybar/sleek/colors.ini"
RFILE="$HOME/.config/Rofi/styles/colors.rasi"
#WALL_LOC=$(cat  ~/.config/nitrogen/bg-saved.cfg | grep "file="|cut -d'=' -f 2)
WALL_LOC=$1
# Get colors
pywal_get() {
	wal -i "$1" -q -t
}

change_waybar(){
	/bin/cp -f ~/.cache/wal/way-bar-colors.css ~/.config/waybar/block/colors.css
}

change_cava(){
	CAVA_CONF="$HOME/.config/cava/config"
  sed -i -e "s/gradient_color_1 = .*/gradient_color_1 = \"${color1}\"/g" $CAVA_CONF 
  sed -i -e "s/gradient_color_2 = .*/gradient_color_2 = \"${color2}\"/g" $CAVA_CONF 
  sed -i -e "s/gradient_color_3 = .*/gradient_color_3 = \"${color3}\"/g" $CAVA_CONF 
  sed -i -e "s/gradient_color_4 = .*/gradient_color_4 = \"${color4}\"/g" $CAVA_CONF 
  sed -i -e "s/gradient_color_5 = .*/gradient_color_5 = \"${color5}\"/g" $CAVA_CONF 
  sed -i -e "s/gradient_color_6 = .*/gradient_color_6 = \"${color6}\"/g" $CAVA_CONF 
  sed -i -e "s/gradient_color_7 = .*/gradient_color_7 = \"${color7}\"/g" $CAVA_CONF 
  sed -i -e "s/gradient_color_8 = .*/gradient_color_8 = \"${color8}\"/g" $CAVA_CONF 
}

change_xmonad(){
 XMONAD_MONNET="$HOME/.xmonad/lib/My/Themes/Monnet.hs"
 sed -i -e "s/colorBack = .*/colorBack = \"#${BG}\"/g" $XMONAD_MONNET
 sed -i -e "s/colorFore = .*/colorFore = \"#${FG}\"/g" $XMONAD_MONNET
 sed -i -e "s/accent = .*/accent = \"${AC}\"/g" $XMONAD_MONNET

 sed -i -e "s/color0 = .*/color0 = \"${color0}\"/g" $XMONAD_MONNET
 sed -i -e "s/color1 = .*/color1 = \"${color1}\"/g" $XMONAD_MONNET
 sed -i -e "s/color2 = .*/color2 = \"${color2}\"/g" $XMONAD_MONNET
 sed -i -e "s/color3 = .*/color3 = \"${color3}\"/g" $XMONAD_MONNET
 sed -i -e "s/color4 = .*/color4 = \"${color4}\"/g" $XMONAD_MONNET
 sed -i -e "s/color5 = .*/color5 = \"${color5}\"/g" $XMONAD_MONNET
 sed -i -e "s/color6 = .*/color6 = \"${color6}\"/g" $XMONAD_MONNET
 sed -i -e "s/color7 = .*/color7 = \"${color7}\"/g" $XMONAD_MONNET
 sed -i -e "s/color8 = .*/color8 = \"${color8}\"/g" $XMONAD_MONNET
 sed -i -e "s/color9 = .*/color9 = \"${color9}\"/g" $XMONAD_MONNET
 sed -i -e "s/color10 = .*/color10 = \"${color10}\"/g" $XMONAD_MONNET
 sed -i -e "s/color11 = .*/color11 = \"${color11}\"/g" $XMONAD_MONNET
 sed -i -e "s/color12 = .*/color12 = \"${color12}\"/g" $XMONAD_MONNET
 sed -i -e "s/color13 = .*/color13 = \"${color13}\"/g" $XMONAD_MONNET
 sed -i -e "s/color14 = .*/color14 = \"${color14}\"/g" $XMONAD_MONNET
 sed -i -e "s/color15 = .*/color15 = \"${color15}\"/g" $XMONAD_MONNET

}

change_awesome(){
 AWESOME_MONNET="$HOME/.config/awesome/theme/monnet.lua"
 sed -i -e "s/.* hue_100 = .*/             hue_100 = \"${color0}\",/g" $AWESOME_MONNET
 sed -i -e "s/.* hue_200 = .*/             hue_200 = \"${color1}\",/g" $AWESOME_MONNET
 sed -i -e "s/.* hue_100 = .*/             hue_100 = \"${color2}\",/g" $AWESOME_MONNET
 sed -i -e "s/.* hue_200 = .*/             hue_200 = \"${color3}\",/g" $AWESOME_MONNET
 sed -i -e "s/.* hue_300 = .*/             hue_300 = \"${color4}\",/g" $AWESOME_MONNET
 sed -i -e "s/.* hue_400 = .*/             hue_400 = \"${color5}\",/g" $AWESOME_MONNET
 sed -i -e "s/.* hue_500 = .*/             hue_500 = \"${color6}\",/g" $AWESOME_MONNET
 sed -i -e "s/.* hue_600 = .*/             hue_600 = \"${color7}\",/g" $AWESOME_MONNET
 sed -i -e "s/.* hue_700 = .*/             hue_700 = \"${color8}\",/g" $AWESOME_MONNET
 sed -i -e "s/.* hue_800 = .*/             hue_800 = \"${color9}\",/g" $AWESOME_MONNET
# sed -i -e "s/color10 = .*/color10 = \"${color10}\"/g" $XMONAD_MONNET
# sed -i -e "s/color11 = .*/color11 = \"${color11}\"/g" $XMONAD_MONNET
# sed -i -e "s/color12 = .*/color12 = \"${color12}\"/g" $XMONAD_MONNET
# sed -i -e "s/color13 = .*/color13 = \"${color13}\"/g" $XMONAD_MONNET
# sed -i -e "s/color14 = .*/color14 = \"${color14}\"/g" $XMONAD_MONNET
# sed -i -e "s/color15 = .*/color15 = \"${color15}\"/g" $XMONAD_MONNET

}

# Change colors
change_color() {
	# polybar
	sed -i -e "s/background = #.*/background = #${BG}/g" $PFILE
	sed -i -e "s/background-alt = #.*/background-alt = #8C${BG}/g" $PFILE
	sed -i -e "s/foreground = #.*/foreground = #${FG}/g" $PFILE
	sed -i -e "s/foreground-alt = #.*/foreground-alt = #33${FG}/g" $PFILE
  sed -i -e "s/accent = #.*/accent = $AC/g" $PFILE


	# rofi
	cat > $RFILE <<- EOF
	/* colors */

	* {
	  al:   #00000000;
	  bg:   #${BG}BF;
	  bga:  #${BG}FF;
	  fg:   #${FG}FF;
	  ac:   ${AC}FF;
	  se:   ${AC}1A;
	}
	EOF

  change_xmonad
	change_awesome
	change_waybar
  change_cava
	current_wm="$(wmctrl -m | grep -i "name" | cut -d: -f 2 | cut -d ' ' -f2)"
	#acitve_window="$(wmctrl -lp | grep $(xprop -root | grep _NET_ACTIVE_WINDOW | head -1 | awk '{print $5}' | sed 's/,//' | sed 's/^0x/0x0/') | awk '{print $1}')"
	#acitve_window="$(printf 0x%x $(xdotool getactivewindow))"
	active_window_pid="$(xdotool getactivewindow getwindowpid)"
	wid=$(wmctrl -lp | grep "$APP_PID" | awk '{print $1}')
	case $current_wm in
					awesome)
								echo 'awesome.restart()' | awesome-client&
								;;
				  xmonad)
								xmonad --restart &
								;;
			 	  *)
                ;;
  esac
	sleep 2 && wmctrl -iR "$wid" #wmctrl -a **$active_window** -i #xdotool key --window "$active_window" F5 && xdotool windowactivate "$active_window"
	if command -v polybar-msg &> /dev/null ;then
				polybar-msg cmd restart
	fi
}

# Main
if [[ -f "/usr/bin/wal" ]] || $(python -c "import pywal"); then
	if [[ "$1" ]]; then
		pywal_get "$1"

		# Source the pywal color file
		. "$HOME/.cache/wal/colors.sh"

		BGC=`printf "%s\n" "$background"`
		BG=${BGC:1}
		FGC=`printf "%s\n" "$foreground"`
		FG=${FGC:1}
		AC=`printf "%s\n" "$color1"`

		change_color
	elif [[ "$WALL_LOC" ]]; then
		pywal_get "$WALL_LOC"

		# Source the pywal color file
		. "$HOME/.cache/wal/colors.sh"

		BGC=`printf "%s\n" "$background"`
		BG=${BGC:1}
		FGC=`printf "%s\n" "$foreground"`
		FG=${FGC:1}
		AC=`printf "%s\n" "$color1"`

		change_color
	else
		echo -e "[!] Please enter the path to wallpaper. \n"
		echo "Usage : ./pywal.sh path/to/image"
	fi
else
	echo "[!] 'pywal' is not installed."
fi
