#!/usr/bin/env fish

if type -q nvim 
    alias vim="nvim" 
    alias vimdiff="nvim -d"
    alias bvim="NVIM_APPNAME=nvim_12 ~/workspace/bin/nvim-linux-x86_64/bin/nvim"
end

alias ls="ls -hN --color=auto --group-directories-first"

if type -q bat
    alias cat="bat"
end

if type -q yt-dlp
	alias _yt="yt-dlp"
else if type -q youtube-dl
	alias _yt="youtube-dl"
end



alias clear="clear && printf '\e[3J'"

alias la='ls -a'
alias ll='ls -la'
alias lt='ls --tree'

alias cp="cp -iv" 
alias mv="mv -iv"
alias rm="rm -vi"
alias mkd="mkdir -pv"

alias yt="_yt --add-metadata -i"
alias yta="yt -x -f bestaudio/best"
alias ytmp3="yt -x --audio-format mp3"
alias yt-opus-best="yt -f 'bestaudio/best' -ciw -o '%(title)s.%(ext)s' -v --extract-audio"

alias ffmpeg="ffmpeg -hide_banner"

alias grep="grep --color=auto"
alias diff="diff --color=auto"

alias YT="youtube-viewer"
alias sdn="sudo shutdown -h now"

alias reveal-md="reveal-md --theme night --highlight-theme hybrid --port 1337"

