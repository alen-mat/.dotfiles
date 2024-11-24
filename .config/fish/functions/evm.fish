set LOC "$HOME/.lang-and-build"
function evm -d "envirnonment for stuff" --argument-names lang 
    switch "$lang"
        case 'zig'
            set -g fish_user_paths "$LOC/zig/latest" "$LOC/zig/ls-latest"
            __check_github_rel_data zigtools/zls zls-x86_64-linux.tar.xz ($LOC/zig/ls-latest/zls --version)
            __check_zig_rel_data_ ($LOC/zig/latest/zig version)
        case 'ocaml'
            echo Hi Hexley!
        case '*'
            echo Hi, stranger!
    end
end

function __confirm_update__ --argument-names repo c_ver n_ver rel_url  -d "Check latest version num in github"
    if [ "$n_ver" != "$c_ver" ] 
        set -l download_url (echo "$release_data" | jq --arg asset_name "$asset_name" -r '.assets[] | select(.name | contains($asset_name))| .url')
        printf '%s %s : %s \n %s %s' "[Update]" $repo $n_ver "URL:" $rel_url
        echo "$repo : $n_ver => $rel_url "
    end
end

function __check_github_rel_data --argument-names repo asset_name c_ver  -d "Check latest version num in github"
    set -l file_name /tmp/(string replace / _ "$repo")
    if not test -f $file_name
        curl  -m 10 --connect-timeout 5  "https://api.github.com/repos/$repo/releases/latest" > $file_name
    end
    set -l release_data (cat "$file_name")
    set -l n_ver (echo "$release_data" | jq -r ".tag_name")
    set -l download_url (echo "$release_data" | jq --arg asset_name "$asset_name" -r '.assets[] | select(.name | contains($asset_name))| .url')
    __confirm_update__ $repo $c_ver $n_ver $download_url
end

function __check_zig_rel_data_ --argument c_ver -d "check zig"
    set -l file_name /tmp/zig_bin
    if not test -f $file_name
        curl  -m 10 --connect-timeout 5  "https://ziglang.org/download/index.json" > $file_name
    end
    set -l release_data (cat "$file_name")
    set -l n_ver (echo "$release_data" | jq -r ".master.version")
    set -l download_url (echo "$release_data" | jq --arg asset_name "$asset_name" -r '.master."x86_64-linux".tarball')
    __confirm_update__ "zig-bin" $c_ver $n_ver $download_url
end
