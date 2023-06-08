if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -e fish_user_paths
set -U fish_user_paths $HOME/.local/bin ~/Apps/jdk-15.0.1/bin $fish_user_paths


source ~/.config/fish/exports.fish
source ~/.config/fish/alias.fish

#https://superuser.com/questions/719531/what-is-the-equivalent-of-bashs-and-in-the-fish-shell
function bind_bang
    switch (commandline -t)[-1]
        case "!"
            commandline -t $history[1]; commandline -f repaint
        case "*"
            commandline -i !
    end
end

function bind_dollar
    switch (commandline -t)[-1]
        case "!"
            commandline -t ""
            commandline -f history-token-search-backward
        case "*"
            commandline -i '$'
    end
end

function fish_user_key_bindings
    bind ! bind_bang
    bind '$' bind_dollar
end
#https://superuser.com/questions/719531/what-is-the-equivalent-of-bashs-and-in-the-fish-shell

#starship init fish | source

if set -q VIRTUAL_ENV
    echo -n -s (set_color -b blue white) "(" (basename "$VIRTUAL_ENV") ")" (set_color normal) " "
end
function no_sleep
    while true
        xdotool mousemove 1800 200;
        sleep 20
        xdotool mousemove 300 500;
        sleep 20
    end
end

function config_updated_files
    config st . | fzf  | cut -d' ' -f3
end

function zr
  command zellij run --name "$argv" -- fish -c "$argv"
end
function zrf
  command zellij run --name "$argv" --floating -- fish -c "$argv"
end
function ze
      if [ -n "$argv" ]; # No arguments
            if [ "$argv[1]" = "." ];
                set layout "$(ls | grep 'layout.kdl'| head -n 1)"
                if  test -n "$layout" 
                    echo "Using layout file $layout"
                    zellij action new-tab --layout "$layout" 
                    return
                end
            end
      end
      command zellij edit $argv
end
function zef
  command zellij edit --floating $argv
end

bind \cz 'fg 2>/dev/null; commandline -f repaint'
source ~/.config/fish/optionals.fish
source ~/.config/fish/drac.fish
source ~/.config/fish/batman.fish
source ~/.config/fish/tomorrownight-night.fish
