################################################################

#source $ZSH/oh-my-zsh.sh
function command_not_found_handle {
  local lred='\e[1;31m'   #Light Red
  local lprpl='\e[1;35m'  #Light Purple
  local ylw='\e[1;33m'    #Yellow
  local bold='\e[1m'
  local rst='\e[0m'    #T

	echo "$bold $lred $1$rst$bold not found $rst "
	echo "Search package with :"
	echo "  $lprpl [OFF] $rst :: $bold pacman -F --machinereadable -- /usr/bin/$1 $rst"
  echo "          :: $bold pacman -Ss $1 $rst"
	echo "  $lprpl [AUR] $rst :: $bold aura -As $1 $rst"

}
# User configuration
source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/exportsrc"
source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc"
source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/custom"


eval "$(starship init bash)"

#[[ -f  ~/.cache/wal/sequences ]] && cat ~/.cache/wal/sequences
