set -U fish_greeting ""

set -x XDG_CONFIG_HOME $HOME/.config
set -x XDG_CACHE_HOME $HOME/.cache
set -x XDG_DATA_HOME $HOME/.local/share
set -x XDG_STATE_HOME $HOME/.local/state
#XDG_RUNTIME_DIR #pam_systemd sets this to /run/user/$UID
#analogous to PATH
set -x XDG_DATA_DIRS /usr/local/share:/usr/share
set -x XDG_CONFIG_DIRS /etc/xdg

# Default programs:
set -x EDITOR "vim"
set -x TERMINAL "kitty"
set -x BROWSER "firefox"
set -x VISUAL "vim"
set -x READER "zathura"
set -x VIDEO "mpv"
set -x IMAGE "sxiv"
set -x COLORTERM "truecolor"
set -x OPENER "xdg-open"
set -x PAGER "less"
set -x WM "xmonad"

set -x __WS         '~/WorkSpace'
set -x SUDO_PROMPT  '[sudo] %p 🔒 : '

set -x QT_STYLE_OVERRIDE            kvantum
set -x QT_QPA_PLATFORMTHEME         "qt5ct"  
set -x QT_AUTO_SCREEN_SCALE_FACTOR  1
set -x GTK_IM_MODULE               'fcitx'
set -x QT_IM_MODULE                'fcitx'
set -x SDL_IM_MODULE               'fcitx'
set -x XMODIFIERS                  '@im fcitx'


# Scaling
set -x QT_AUTO_SCREEN_SCALE_FACTOR 0
set -x QT_SCALE_FACTOR 1
set -x QT_SCREEN_SCALE_FACTORS "1;1;1"
set -x GDK_SCALE 1
set -x GDK_DPI_SCALE 1

set -x TERM      xterm-color
set -x CLICOLOR  1
set -x LS_COLORS 'rs 0:di 01;34:ln 01;36:mh 00:pi 40;33'

fish_add_path $__R3N/scripts
fish_add_path $__APPS/meld-3.20.2/bin/
fish_add_path $HOME/.local/bin/
fish_add_path $HOME/Apps/jdk-15.0.1/bin
fish_add_path $HOME/.jbang/bin

set -x LANG en_US.UTF-8
set -x LESS "-R"

if type -q bat
	set -x BAT_CONFIG_DIR "$XDG_CONFIG_HOME/batcat"
	set -x BAT_CONFIG_PATH "$BAT_CONFIG_DIR/batcat.cfg"
	set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"
else
	set -x LESS_TERMCAP_mb "(printf '%b' '\e[1;31m')"
	set -x LESS_TERMCAP_md "(printf '%b' '\e[1;36m')"
	set -x LESS_TERMCAP_me "(printf '%b' '\e[0m')"
	set -x LESS_TERMCAP_so "(printf '%b' '\e[01;44;33m')"
	set -x LESS_TERMCAP_se "(printf '%b' '\e[0m')"
	set -x LESS_TERMCAP_us "(printf '%b' '\e[1;32m')"
	set -x LESS_TERMCAP_ue "(printf '%b' '\e[0m')"
	set -x LESSOPEN "| /usr/bin/highlight -O ansi %s 2>/dev/null"

	set -x MANPAGER "less -R --use-color -Dd+r -Du+b"
end

set -x JAVA_HOME /usr/lib/jvm/java-8-openjdk 

#set -x XINITRC "${XDG_CONFIG_HOME:-$HOME/.config}/x11/xinitrc"
#set -x XAUTHORITY "$XDG_RUNTIME_DIR/Xauthority" # This line will break some DMs.
set -x NOTMUCH_CONFIG "$HOME/.config/notmuch-config"
set -x GTK2_RC_FILES "$HOME/.config/gtk-2.0/gtkrc-2.0"
set -x LESSHISTFILE "-"
set -x WGETRC "$HOME/.config/wget/wgetrc"
set -x INPUTRC "$HOME/.config/shell/inputrc"
set -x ZDOTDIR "$HOME/.config/zsh"
#set -x ALSA_CONFIG_PATH "$XDG_CONFIG_HOME/alsa/asoundrc"
#set -x GNUPGHOME "$HOME/.local/share/gnupg"
set -x WINEPREFIX "$HOME/.local/share/wineprefixes/default"
set -x KODI_DATA "$HOME/.local/share/kodi"
set -x PASSWORD_STORE_DIR "$HOME/.local/share/password-store"
set -x TMUX_TMPDIR "$XDG_RUNTIME_DIR"
set -x ANDROID_SDK_HOME "$HOME/.config/android"
set -x CARGO_HOME "$HOME/.local/share/cargo"
set -x GOPATH "$HOME/.local/share/go"
set -x ANSIBLE_CONFIG "$HOME/.config/ansible/ansible.cfg"
set -x UNISON "$HOME/.local/share/unison"
set -x HISTFILE "$HOME/.local/share/history"

# Other program settings:
set -x DICS "/usr/share/stardict/dic/"
set -x SUDO_ASKPASS "$HOME/.config/rofi/applets/askpass.sh"
set -x FZF_DEFAULT_OPTS "--layout reverse --height 40%"
set -x QT_QPA_PLATFORMTHEME "gtk2"	# Have QT use gtk2 theme.
set -x MOZ_USE_XINPUT2 "1"		# Mozilla smooth scrolling/touchpads.
set -x AWT_TOOLKIT "MToolkit wmname LG3D"	#May have to install wmname
set -x _JAVA_AWT_WM_NONREPARENTING 1	# Fix for Java applications in dwm

# This is the list for lf icons:
set -x LF_ICONS "di 📁:\
fi 📃:\
tw 🤝:\
ow 📂:\
ln ⛓:\
or ❌:\
ex 🎯:\
*.txt ✍:\
*.mom ✍:\
*.me ✍:\
*.ms ✍:\
*.png 🖼:\
*.webp 🖼:\
*.ico 🖼:\
*.jpg 📸:\
*.jpe 📸:\
*.jpeg 📸:\
*.gif 🖼:\
*.svg 🗺:\
*.tif 🖼:\
*.tiff 🖼:\
*.xcf 🖌:\
*.html 🌎:\
*.xml 📰:\
*.gpg 🔒:\
*.css 🎨:\
*.pdf 📚:\
*.djvu 📚:\
*.epub 📚:\
*.csv 📓:\
*.xlsx 📓:\
*.tex 📜:\
*.md 📘:\
*.r 📊:\
*.R 📊:\
*.rmd 📊:\
*.Rmd 📊:\
*.m 📊:\
*.mp3 🎵:\
*.opus 🎵:\
*.ogg 🎵:\
*.m4a 🎵:\
*.flac 🎼:\
*.wav 🎼:\
*.mkv 🎥:\
*.mp4 🎥:\
*.webm 🎥:\
*.mpeg 🎥:\
*.avi 🎥:\
*.mov 🎥:\
*.mpg 🎥:\
*.wmv 🎥:\
*.m4b 🎥:\
*.flv 🎥:\
*.zip 📦:\
*.rar 📦:\
*.7z 📦:\
*.tar.gz 📦:\
*.z64 🎮:\
*.v64 🎮:\
*.n64 🎮:\
*.gba 🎮:\
*.nes 🎮:\
*.gdi 🎮:\
*.1 ℹ:\
*.nfo ℹ:\
*.info ℹ:\
*.log 📙:\
*.iso 📀:\
*.img 📀:\
*.bib 🎓:\
*.ged 👪:\
*.part 💔:\
*.torrent 🔽:\
*.jar ♨:\
*.java ♨:\
"

