# ---------------------------
# Completions for `e` function
# Uses NVIM_SHADA_FILE if set
# ---------------------------

# ---------------------------
# Flags
# ---------------------------
complete -c e -s s -l split -d "Open in terminal split"
complete -c e -s n -l neovide -d "Open in Neovide GUI"
complete -c e -l bvim -d "Use bvim binary instead of nvim"
complete -c e -f -a '--' -d "End of options; following args go to nvim"

# ---------------------------
# Recent files/folders completion
# ---------------------------
function __e_recent_usage
    set -l recent

    # Only use shada if NVIM_SHADA_FILE is set
    if set -q NVIM_SHADA_FILE
        if test -f $NVIM_SHADA_FILE
            for f in (nvim --headless -c "echo join(map({v -> v.file}, v:oldfiles), ' ')" -c q 2>/dev/null)
                if test -e $f
                    set recent $recent $f
                end
            end
        end
    end

    # Always include filesystem fallback: files/dirs in current dir, sorted by mtime
    for f in (ls -1t 2>/dev/null)
        if not contains $f $recent
            set recent $recent $f
        end
    end

    # Output combined list
    for item in $recent
        echo $item
    end
end

# ---------------------------
# Apply completion
# ---------------------------
complete -c e -f -a "(__e_recent_usage)"
