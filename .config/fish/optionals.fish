# Use neovim for vim if present.
if type -q nvim 
	alias vim="nvim" 
	alias vimdiff="nvim -d"
end

if type -q helix
    alias hx="helix"
end

if type -q glow
	alias glow="glow -p"
end

if type -q exa
	alias ls="exa --icons"
else if type -q lsd 
	alias ls="lsd"
else 
	alias ls="ls -hN --color=auto --group-directories-first"
end

if type -q bat
	if type -q fzf
		alias pfzf="fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}'"
	end
	alias cat="bat"
	set -Ux BAT_CONFIG_DIR "$XDG_CONFIG_HOME/batcat"
	set -Ux BAT_CONFIG_PATH "$BAT_CONFIG_DIR/batcat.cfg"
	set -Ux MANPAGER "sh -c 'col -bx | bat -l man -p'"
else
	set -Ux LESS_TERMCAP_mb (printf '%b' '\e[1;31m')
	set -x LESS_TERMCAP_md (printf '%b' '\e[1;36m')
	set -Ux LESS_TERMCAP_me (printf '%b' '\e[0m')
	set -Ux LESS_TERMCAP_so (printf '%b' '\e[01;44;33m')
	set -Ux LESS_TERMCAP_se (printf '%b' '\e[0m')
	set -Ux LESS_TERMCAP_us (printf '%b' '\e[1;32m')
	set -Ux LESS_TERMCAP_ue (printf '%b' '\e[0m')
	set -Ux LESSOPEN "| /usr/bin/highlight -O ansi %s 2>/dev/null"

	set -Ux MANPAGER "less -R --use-color -Dd+r -Du+b"
end

if type -q yt-dlp
	alias _yt="yt-dlp"
else if type -q youtube-dl
	alias _yt="youtube-dl"
end


