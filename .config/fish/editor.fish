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

    if set -q HYPRLAND_INSTANCE_SIGNATURE
        hyprctl dispatch exec -- neovide $args
    else
        neovide $args
    end
end
