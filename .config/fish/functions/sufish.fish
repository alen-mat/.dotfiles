function sufish --description "Switch to a user with Fish as the login shell (usage: fsu <username>)"
    if test (count $argv) -ne 1
        echo "Usage: fsu <username>" >&2
        return 1
    end

    su - $argv[1] -s /usr/bin/fish
end
