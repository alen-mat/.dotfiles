function env-manager --argument-names lang -d "setup envirnonment for stuff"
    switch "$lang"
        case 'zig'
            fish_add_path $HOME/.lang-and-build/zig/latest
        case 'ocaml'
            echo Hi Hexley!
        case '*'
            echo Hi, stranger!
    end
end
