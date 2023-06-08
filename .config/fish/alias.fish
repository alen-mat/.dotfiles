#!/bin/sh

alias init_java="mkdir -p {lib,bin,src/{main/{java,resources,filters,assembly,config,webapp},test/{java,resources,filters},site}}"
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

alias clear="clear && printf '\e[3J'"

alias emct="emacsclient -nw -c"
alias emc="emacsclient -c --no-wait"
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
alias ffmpeg="ffmpeg -hide_banner"

alias grep="grep --color=auto"
alias diff="diff --color=auto"
alias ccat="highlight --out-format=ansi"

alias trem="transmission-remote"
alias YT="youtube-viewer"
alias sdn="sudo shutdown -h now"

alias ref="shortcuts >/dev/null; source $HOME/.config/shortcutrc ; source $HOME/.config/zshnameddirrc"
alias weath="less -S $HOME/.local/share/weatherreport" 

alias reveal-md="reveal-md --theme night --highlight-theme hybrid --port 1337"
alias nis='npm i -S'

#######
alias set_server_opts='export JAVA_OPTS="-XX:PermSize=250M -XX:MaxPermSize=250M -Xms256m -Xmx512m -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=8991"'

alias j!=jbang
