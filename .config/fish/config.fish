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

starship init fish | source
