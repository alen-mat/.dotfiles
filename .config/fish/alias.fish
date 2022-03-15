#!/bin/sh

alias init_java="mkdir -p {lib,bin,src/{main/{java,resources,filters,assembly,config,webapp},test/{java,resources,filters},site}}"
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
# Use neovim for vim if present.
if type -q nvim 
	alias vim="nvim" 
	alias vimdiff="nvim -d"
end

if type -q lsd 
	alias ls="lsd"
	alias l='ls'
	alias la='ls -a'
	alias ll='ls -la'
	alias lt='ls --tree'
else 
	alias ls="ls -hN --color=auto --group-directories-first"
	alias l="ls" # List files in current directory
	alias ll="ls -al" # List all files in current directory in long list format
end

if type -q bat
	if type -q fzf
		alias pfzf="fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}'"
	end
	alias cat="bat"
end

alias clear="clear && printf '\e[3J'"

alias cp="cp -iv" 
alias mv="mv -iv"
alias rm="rm -vi"
alias mkd="mkdir -pv"
alias yt="youtube-dl --add-metadata -i"
alias yta="yt -x -f bestaudio/best"
alias ffmpeg="ffmpeg -hide_banner"

alias grep="grep --color=auto"
alias diff="diff --color=auto"
alias ccat="highlight --out-format=ansi"

alias trem="transmission-remote"
alias YT="youtube-viewer"
alias sdn="sudo shutdown -h now"
alias p="sudo pacman"
alias z="zathura"

alias magit="nvim -c MagitOnly"
alias ref="shortcuts >/dev/null; source $HOME/.config/shortcutrc ; source $HOME/.config/zshnameddirrc"
alias weath="less -S $HOME/.local/share/weatherreport" 

alias reveal-md="reveal-md --theme night --highlight-theme hybrid --port 1337"
alias nis='npm i -S'

#######
alias set_server_opts='export JAVA_OPTS="-XX:PermSize=250M -XX:MaxPermSize=250M -Xms256m -Xmx512m -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=8991"'

alias j!=jbang

alias ytube-mp3="youtube-dl --extract-audio --audio-format mp3 "
