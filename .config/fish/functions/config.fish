function config --description 'Dotfiles git'
    /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME $argv
end
