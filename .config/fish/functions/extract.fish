function extract -a file --description 'Extract archive'
    if test -f "$file"
        switch "$file"
            case "*.tar.bz2"
                tar xjf $file
            case "*.tar.gz"
                tar xzf $file
            case "*.tar.xz"
                tar -xJf 
            case "*.tar"
                tar xf $file
            case "*.tbz2"
                tar xjf $file
            case "*.tgz"
                tar xzf $file
            case "*.bz2"
                bunzip2 $file
            case "*.rar"
                unrar x $file
            case "*.gz"
                gunzip $file
            case "*.zip"
                unzip $file
            case "*.Z"
                uncompress $file
            case "*.7z"
                7z x $file
            case "*"
                echo "'$file' cannot be extracted via ex()"
        end
    else
        echo "'$file' is not a valid file"
    end
end
