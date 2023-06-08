set -U fish_greeting ""

set -Ux XDG_CONFIG_HOME $HOME/.config
set -Ux XDG_CACHE_HOME $HOME/.cache
set -Ux XDG_DATA_HOME $HOME/.local/share
set -Ux XDG_STATE_HOME $HOME/.local/state
#XDG_RUNTIME_DIR #pam_systemd sets this to /run/user/$UID
#analogous to PATH
set -Ux XDG_DATA_DIRS /usr/local/share:/usr/share
set -Ux XDG_CONFIG_DIRS /etc/xdg

# Default programs:
set -Ux EDITOR "/usr/bin/nvim"
set -Ux TERMINAL "/usr/bin/alacritty"
set -Ux BROWSER "/usr/bin/firefox"
set -Ux VISUAL "/usr/bin/nvim" #"neovide"
set -Ux READER "/usr/bin/zathura"
set -Ux VIDEO "/usr/bin/mpv"
set -Ux IMAGE "/usr/bin/sxiv"
set -Ux COLORTERM "/usr/bin/truecolor"
set -Ux OPENER "/usr/bin/xdg-open"
set -Ux PAGER "/usr/bin/less"
set -Ux WM "/usr/bin/xmonad"

set -Ux GIT_EDITOR $VISUAL 

set -Ux __WS         '~/WorkSpace'
set -Ux SUDO_PROMPT  '[sudo] %p 🔒 : '

set -Ux QT_STYLE_OVERRIDE            kvantum #kvantum-dark 
set -Ux QT_QPA_PLATFORMTHEME         "qt5ct"  
set -Ux QT_AUTO_SCREEN_SCALE_FACTOR  1
set -Ux GTK_IM_MODULE               'fcitx'
set -Ux QT_IM_MODULE                'fcitx'
set -Ux SDL_IM_MODULE               'fcitx'
set -Ux XMODIFIERS                  '@im fcitx'


# Scaling
set -Ux QT_AUTO_SCREEN_SCALE_FACTOR 0
set -Ux QT_SCALE_FACTOR 1
set -Ux QT_SCREEN_SCALE_FACTORS "1;1;1"
set -Ux GDK_SCALE 1
set -Ux GDK_DPI_SCALE 1

#set -Ux TERM      xterm-color
set -Ux CLICOLOR  1
set -Ux LS_COLORS 'rs 0:di 01;34:ln 01;36:mh 00:pi 40;33'

fish_add_path $__R3N/scripts
fish_add_path $__APPS/meld-3.20.2/bin/
fish_add_path $HOME/.local/bin/
fish_add_path $HOME/Apps/jdk-15.0.1/bin
fish_add_path $HOME/.jbang/bin

set -Ux LANG en_US.UTF-8
set -Ux LESS "-R"


set -x JAVA_HOME '/usr/lib/jvm/default'

#set -Ux XINITRC "${XDG_CONFIG_HOME:-$HOME/.config}/x11/xinitrc"
#set -Ux XAUTHORITY "$XDG_RUNTIME_DIR/Xauthority" # This line will break some DMs.
set -Ux NOTMUCH_CONFIG "$HOME/.config/notmuch-config"
set -Ux GTK2_RC_FILES "$HOME/.config/gtk-2.0/gtkrc-2.0"
set -Ux LESSHISTFILE "-"
set -Ux WGETRC "$HOME/.config/wget/wgetrc"
set -Ux INPUTRC "$HOME/.config/shell/inputrc"
set -Ux ZDOTDIR "$HOME/.config/zsh"
#set -Ux ALSA_CONFIG_PATH "$XDG_CONFIG_HOME/alsa/asoundrc"
#set -Ux GNUPGHOME "$HOME/.local/share/gnupg"
set -Ux WINEPREFIX "$HOME/.local/share/wineprefixes/default"
set -Ux KODI_DATA "$HOME/.local/share/kodi"
set -Ux PASSWORD_STORE_DIR "$HOME/.local/share/password-store"
set -Ux TMUX_TMPDIR "$XDG_RUNTIME_DIR"
set -Ux ANDROID_SDK_HOME "$HOME/.config/android"
set -Ux CARGO_HOME "$HOME/.local/share/cargo"
set -Ux GOPATH "$HOME/.local/share/go"
set -Ux ANSIBLE_CONFIG "$HOME/.config/ansible/ansible.cfg"
set -Ux UNISON "$HOME/.local/share/unison"
set -Ux HISTFILE "$HOME/.local/share/history"

# Other program settings:
set -Ux DICS "/usr/share/stardict/dic/"
set -Ux SUDO_ASKPASS "$HOME/.config/rofi/scripts/askpass.sh"
set -Ux FZF_DEFAULT_OPTS "--layout reverse --height 40%"
#set -Ux QT_QPA_PLATFORMTHEME "gtk2" # Have QT use gtk2 theme.
set -Ux MOZ_USE_XINPUT2 "1"		# Mozilla smooth scrolling/touchpads.
set -Ux AWT_TOOLKIT "MToolkit wmname LG3D"	#May have to install wmname
set -Ux _JAVA_AWT_WM_NONREPARENTING 1	# Fix for Java applications in dwm
