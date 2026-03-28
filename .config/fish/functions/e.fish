function e
    # ---------------------------
    # Flexible Neovim / Neovide / Bvim launcher
    # Usage:
    #   e [file_or_dir ...] [-s/--split] [-n/--neovide] [--bvim] [-- nvim args]
    # ---------------------------

    # Initialize
    set -l split_flag 0
    set -l neovide_flag 0
    set -l bvim_flag 0
    set -l file_args
    set -l nvim_args
    set -l parsing_nvim_args 0

    for arg in $argv
        if test $parsing_nvim_args -eq 1
            set nvim_args $nvim_args $arg
            continue
        end

        switch $arg
            case '--'
                set parsing_nvim_args 1
            case -s --split
                set split_flag 1
            case -n --neovide
                set neovide_flag 1
            case --bvim
                set bvim_flag 1
            case '*'
                set file_args $file_args $arg
        end
    end

    # Default target is current directory if no files provided
    if test (count $file_args) -eq 0
        set file_args .
    end

    # Determine target directory for cd (first file)
    set -l first_target $file_args[1]
    if test -d "$first_target"
        set target_dir "$first_target"
    else if test -f "$first_target"
        set target_dir (dirname "$first_target")
    else
        set target_dir .
    end

    # Decide which binary to use
    set -l editor nvim
    if test $bvim_flag -eq 1
        set editor bvim
    else if test $neovide_flag -eq 1
        set editor neovide
    end

    # ---------------------------
    # GUI mode (Neovide or bvim GUI)
    # ---------------------------
    if test $neovide_flag -eq 1 -o $bvim_flag -eq 1
        if not type -q $editor
            echo "Error: $editor not found"
            return 1
        end
        nohup $editor -- -c "cd $target_dir" -- $file_args $nvim_args >/dev/null 2>&1 &
        return
    end

    # ---------------------------
    # Terminal split mode
    # ---------------------------
    if test $split_flag -eq 1
        if set -q WEZTERM_PANE
            if not type -q $editor
                echo "Error: $editor not found"
                return 1
            end
            wezterm cli split-pane -- $editor -- $file_args $nvim_args
            return
        else if set -q KITTY_WINDOW_ID
            if not type -q $editor
                echo "Error: $editor not found"
                return 1
            end
            kitty @ new-window --cwd "$target_dir" $editor -- $file_args $nvim_args
            return
        else if set -q GHOSTTTY
            if not type -q $editor
                echo "Error: $editor not found"
                return 1
            end
            ghostty send "cd $target_dir && $editor -- $file_args $nvim_args"
            return
        else
            echo "Warning: split requested, but no supported terminal detected. Falling back to normal $editor."
        end
    end

    # ---------------------------
    # Default terminal editor
    # ---------------------------
    if not type -q $editor
        echo "Error: $editor not found"
        return 1
    end
    $editor -- $file_args $nvim_args
end
