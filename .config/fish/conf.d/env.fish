 #---------------------------
 # XDG Base Directories
 # ---------------------------
 #  set -gx XDG_CONFIG_HOME $HOME/.config
 #  set -gx XDG_CACHE_HOME  $HOME/.cache
 #  set -gx XDG_DATA_HOME   $HOME/.local/share
 #  set -gx XDG_STATE_HOME  $HOME/.local/state
 # 
 #  set -gx XDG_DATA_DIRS /usr/local/share /usr/share
 #  set -gx XDG_CONFIG_DIRS /etc/xdg

 # ---------------------------
 # Default Programs
 # ---------------------------
 set -gx EDITOR   /usr/bin/nvim
 set -gx VISUAL   /usr/bin/nvim

 # ---------------------------
 # Pager / Viewer (conditional bat)
 # ---------------------------
 if command -q bat
	# Use bat for enhanced experience
	set -gx PAGER bat
	set -gx BAT_PAGER "less -FR"
	set -gx MANPAGER "sh -c 'col -bx | bat -l man'"
else
	# Fallback to cat safely
	set -gx PAGER cat
	set -gx MANPAGER "sh -c 'col -bx | cat'"
end

set -gx GIT_EDITOR $VISUAL

# ---------------------------
# Locale & Terminal
# ---------------------------
set -gx LANG en_US.UTF-8
set -gx COLORTERM truecolor
set -gx CLICOLOR 1

# ---------------------------
# Useful defaults
# ---------------------------
set -gx SUDO_PROMPT '[sudo] %p 🔒 : '
# set -gx MOZ_USE_XINPUT2 1

# ---------------------------
# Optional tools
# ---------------------------
set -gx FZF_DEFAULT_OPTS "--layout reverse --height 40%"
