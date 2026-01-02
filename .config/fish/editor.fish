function e
    argparse 's/split' -- $argv
    or return

    set nvim_args $argv
    if test (count $nvim_args) -eq 0
        set nvim_args .
    end

    if set -q _flag_split; and set -q WEZTERM_PANE
        wezterm cli split-pane -- nvim -- $nvim_args
    else
        nvim $nvim_args
    end
end
function nv
    set args $argv
    if test (count $args) -eq 0
        set args .
    end

    set first $args[1]
    if test -d $first
        # set args "--cmd 'cd $first'" $args
        set args[1] " -c 'cd $first' "
        echo $args
    else if test -f $first
        set parent (dirname $first)
        set args " -c 'cd $parent' " $args
        echo $args
    end

    eval "nohup neovide --  $args >/dev/null 2>&1 &"
end
