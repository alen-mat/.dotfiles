set -g fish_greeting ""

set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_CACHE_HOME $HOME/.cache
set -gx XDG_DATA_HOME $HOME/.local/share
set -gx XDG_STATE_HOME $HOME/.local/state
#XDG_RUNTIME_DIR #pam_systemd sets this to /run/user/$UID
#analogous to PATH
set -gx XDG_DATA_DIRS /usr/local/share:/usr/share
set -gx XDG_CONFIG_DIRS /etc/xdg

# Default programs:
set -gx EDITOR "/usr/bin/nvim"
set -gx TERMINAL "/usr/bin/alacritty"
set -gx BROWSER "/usr/bin/firefox"
set -gx VISUAL "/usr/bin/nvim" #"neovide"
set -gx READER "/usr/bin/zathura"
set -gx VIDEO "/usr/bin/mpv"
set -gx IMAGE "/usr/bin/sxiv"
set -gx COLORTERM "/usr/bin/truecolor"
set -gx OPENER "/usr/bin/xdg-open"
set -gx PAGER "/usr/bin/less"
set -gx WM "/usr/bin/awesome"

set -gx GIT_EDITOR $VISUAL 

set -gx __WS         '~/WorkSpace'
set -gx SUDO_PROMPT  '[sudo] %p 🔒 : '

set -gx QT_STYLE_OVERRIDE            kvantum #kvantum-dark 
set -gx QT_QPA_PLATFORMTHEME         "qt5ct"  
set -gx QT_AUTO_SCREEN_SCALE_FACTOR  1
set -gx GTK_IM_MODULE               'fcitx'
set -gx QT_IM_MODULE                'fcitx'
set -gx SDL_IM_MODULE               'fcitx'
set -gx XMODIFIERS                  '@im fcitx'


# Scaling
set -gx QT_AUTO_SCREEN_SCALE_FACTOR 0
set -gx QT_SCALE_FACTOR 1
set -gx QT_SCREEN_SCALE_FACTORS "1;1;1"
set -gx GDK_SCALE 1
set -gx GDK_DPI_SCALE 1

#set -gx TERM      xterm-color
set -gx CLICOLOR  1
set -Ux LS_COLORS 'rs 0:di 01;34:ln 01;36:mh 00:pi 40;33'

set -gx LANG en_US.UTF-8
set -gx LESS "-R"

set -x JAVA_HOME '/usr/lib/jvm/default'

#set -gx XINITRC "${XDG_CONFIG_HOME:-$HOME/.config}/x11/xinitrc"
#set -gx XAUTHORITY "$XDG_RUNTIME_DIR/Xauthority" # This line will break some DMs.
set -gx NOTMUCH_CONFIG "$HOME/.config/notmuch-config"
set -gx GTK2_RC_FILES "$HOME/.config/gtk-2.0/gtkrc-2.0"
set -gx LESSHISTFILE "-"
set -gx WGETRC "$HOME/.config/wget/wgetrc"
set -gx INPUTRC "$HOME/.config/shell/inputrc"
set -gx ZDOTDIR "$HOME/.config/zsh"
#set -gx ALSA_CONFIG_PATH "$XDG_CONFIG_HOME/alsa/asoundrc"
#set -gx GNUPGHOME "$HOME/.local/share/gnupg"
set -gx WINEPREFIX "$HOME/.local/share/wineprefixes/default"
set -gx PASSWORD_STORE_DIR "$HOME/.local/share/password-store"
set -gx TMUX_TMPDIR "$XDG_RUNTIME_DIR"
set -gx ANDROID_SDK_HOME "$HOME/.config/android"
set -gx CARGO_HOME "$HOME/.local/share/cargo"
set -gx GOPATH "$HOME/.local/share/go"
set -gx ANSIBLE_CONFIG "$HOME/.config/ansible/ansible.cfg"
set -gx UNISON "$HOME/.local/share/unison"
set -gx HISTFILE "$HOME/.local/share/history"

# Other program settings:
set -gx DICS "/usr/share/stardict/dic/"
set -gx SUDO_ASKPASS "$HOME/.config/rofi/scripts/askpass.sh"
set -gx FZF_DEFAULT_OPTS "--layout reverse --height 40%"
#set -gx QT_QPA_PLATFORMTHEME "gtk2" # Have QT use gtk2 theme.
set -gx MOZ_USE_XINPUT2 "1"		# Mozilla smooth scrolling/touchpads.
set -gx AWT_TOOLKIT "MToolkit wmname LG3D"	#May have to install wmname
set -gx _JAVA_AWT_WM_NONREPARENTING 1	# Fix for Java applications in dwm

set -gx ICAROOT /opt/Citrix/ICAClient
