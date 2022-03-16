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

change_xmonad(){
 XMONAD_MONNET="$HOME/.xmonad/lib/Colors/Monnet.hs"
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

	polybar-msg cmd restart
  change_xmonad
}

# Main
if [[ -f "/usr/bin/wal" ]]; then
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
