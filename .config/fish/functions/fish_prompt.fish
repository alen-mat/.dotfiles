set -g fish_transient_prompt 1
function fish_prompt
    set -l last_status $status
    set -l stat
    set -l pwd
    # Check if it's a transient or final prompt
    if contains -- --final-rendering $argv
        set pwd ''
    else
        set pwd (prompt_pwd)
        # Prompt status only if it's not 0
        if test $last_status -ne 0
            set stat (set_color red)"[$last_status]"(set_color --reset)
        end
    end

    string join '' -- (set_color green) $pwd (set_color --reset) $stat ' > '
end
function fish_right_prompt -d "Write out the right prompt"
    set -l prmt
    if contains -- --final-rendering $argv
        set prmt ''
    else 
        set prmt (date '+%m/%d/%y')
    end
    string join '' -- $prmt
end
