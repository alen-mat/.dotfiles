function fish_should_add_to_history
    switch $argv[1]
        case 'su *' 'sudo su*' 'sufish*'
            return 1
    end

    return 0
end
