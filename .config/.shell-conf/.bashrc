unset GREP_OPTIONS

export EDITOR=vim

export __WS='~/WorkSpace'

export TERM=xterm-color
export CLICOLOR=1
export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33'

alias set_server_opts='export JAVA_OPTS="-XX:PermSize=250M -XX:MaxPermSize=250M -Xms256m -Xmx512m -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=8991"'

export PATH="$PATH:$__R3N/scripts/"
export PATH="$PATH:$__APPS/meld-3.20.2/bin/"


function run-app(){
  nohup $1 > /dev/null &
}

prompt_modify(){

  unset HG_PROMPT_PREFIX
  unset HG_PROMPT_SUFFIX
  unset HG_PROMPT_DIRTY
  unset HG_PROMPT_CLEAN


  local GREEN="\[\033[0;32m\]"
  local CYAN="\[\033[0;36m\]"
  local RED="\[\033[0;31m\]"
  local PURPLE="\[\033[0;35m\]"
  local BROWN="\[\033[0;33m\]"
  local LIGHT_GRAY="\[\033[0;37m\]"
  local LIGHT_BLUE="\[\033[1;34m\]"
  local LIGHT_GREEN="\[\033[1;32m\]"
  local LIGHT_CYAN="\[\033[1;36m\]"
  local LIGHT_RED="\[\033[1;31m\]"
  local LIGHT_PURPLE="\[\033[1;35m\]"
  local YELLOW="\[\033[1;33m\]"
  local WHITE="\[\033[1;37m\]"
  local RESTORE="\[\033[0m\]"

  #bold_text(){echo -e "\e[1m${1}\e[0m"}
  #italic_text(){echo -e "\e[3m$1\e[0m"}
  #bold_italic_text(){echo -e "\e[3m\e[1m$1\e[0m"}
  #munderline_text(){echo -e "\e[4m$1\e[0m"}
  #strike_through(){echo -e "\e[9m$1\e[0m"}
  #hw(){echo -e "\e[31m$1\e[0m"}
  #hw1(){echo -e "\x1B[31m$1\e[0m"}

  if [[ -d .hg ]] || $(hg summary > /dev/null 2>&1); then
      HG_PROMPT_SYMBOL="$GREEN☿"
      HG_PROMPT_PREFIX="${HG_PROMPT_SYMBOL} $LIGHT_GRAY$(hg id -n):$(hg id -i) | "
      HG_PROMPT_SUFFIX="$(hg id -b)"
  fi
  PS1="$RESTORE[$CYAN\u@\h$RESTORE][$GREEN$(awd)$RESTORE]$\[\033[0m\$RESTORE $WHITE${HG_PROMPT_PREFIX}${HG_PROMPT_SUFFIX}$RESTORE⇒$WHITE "
}

awd(){
    w='\w'; IFS=/ read -a a <<< "${w@P}"    
    ((c=${#a[@]}-1))                        
    for e in "${a[@]::$c}"; do              
        [[ $e =~ ^\. ]]&&l=2||l=1           
        printf '%s/' "${e:0:$l}"            
        done; echo "${a[$c]}"               
}

termtitle() { printf "\033]0;$*\007"; }

#HOST_NAME=minima

#source ~/.nvm/nvm.sh
#nvm use stable
#shopt -s autocd
#shopt -s histappend

#export PATH=$PATH:$HOME/bin

export HISTSIZE=5000
export HISTFILESIZE=10000

export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

txtred='\e[0;31m' # Red
txtgrn='\e[0;32m' # Green
bldgrn='\e[1;32m' # Bold Green
bldpur='\e[1;35m' # Bold Purple
txtrst='\e[0m'    # Text Reset

emojis=("👾" "🌐" "🎲" "🌍" "🐉" "🌵")

EMOJI=${emojis[$RANDOM % ${#emojis[@]} ]}

print_before_the_prompt () {
    dir=$PWD
    home=$HOME
    dir=${dir/"$HOME"/"~"}
    printf "\n $txtred%s: $bldpur%s $txtgrn%s\n$txtrst" "$HOST_NAME" "$dir" #"$(vcprompt)"
}


#fortune | cowsay -f tux

function mkcd()
{
	mkdir $1 && cd $1
}

alias mv='mv -i -v'  
alias rm='rm -i -v'  
alias cp='cp -i -v'
alias grep='grep --color=auto'
alias ..='cd ..'
# -------
# Aliases
# -------
alias 🍺="git checkout -b drunk"
#alias a='code .'
#alias c='code .'
alias reveal-md="reveal-md --theme night --highlight-theme hybrid --port 1337"
alias ns='npm start'
alias start='npm start'
alias nr='npm run'
alias run='npm run'
alias nis='npm i -S'
alias l="ls" # List files in current directory
alias ll="ls -al" # List all files in current directory in long list format
alias o="open ." # Open the current directory in Finder

# ----------------------
# Git Aliases
# ----------------------
alias ga='git add'
alias gaa='git add .'
alias gaaa='git add -A'
alias gc='git commit'
alias gcm='git commit -m'
alias gd='git diff'
alias gi='git init'
alias gl='git log'
alias gp='git pull'
alias gpsh='git push'
alias gss='git status -s'
alias gs='echo ""; echo "*********************************************"; echo -e "   DO NOT FORGET TO PULL BEFORE COMMITTING"; echo "*********************************************"; echo ""; git status'


if [ $(ps -o comm= -p $$) = "bash" ] ;then
	PROMPT_COMMAND=print_before_the_prompt
	PROMPT_COMMAND="history -a; history -c; history -r; PROMPT_COMMAND"
	PS1="$EMOJI > "
	PS2=">> "
	if [ command -v bind &> /dev/null ];then
  		bind '"\e[A": history-search-backward'
		bind '"\e[B": history-search-forward'
	fi
fi


