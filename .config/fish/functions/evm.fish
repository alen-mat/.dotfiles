set LOC "$HOME/.lang-and-build"

function evm -d "envirnonment for stuff" --argument-names lang update
    switch "$lang"
        case 'zig'
            if [ update ]
                __check_zig_rel_data_ ($LOC/zig/latest/zig version)
                __check_github_rel_data zig zigtools/zls "zls-aarch64-linux.tar.(gz|xz)\$" ($LOC/zig/ls-latest/zls --version) 
            else 
                set -g fish_user_paths "$LOC/zig/latest" "$LOC/zig/ls-latest"
            end
        case 'ocaml'
            echo Hi Hexley!
        case '*'
            echo Hi, stranger!
    end
end

function extract --argument-names path topath -d "extract archives"
    echo "tar -C $topath -xf $path"
    tar -C $topath -xf $path
end

function __check_github_rel_data --argument-names lang repo asset_name c_ver  -d "Check latest version num in github"
    set -l durl (curl -s "https://api.github.com/repos/$repo/releases/latest" | jq -r --arg ASSET_NAME "$asset_name" '.assets[] | select(.name | match($ASSET_NAME)) | .browser_download_url')
    echo " - $c_ver => $n_ver "
    set -l fname (string split / $durl)[-1]
    echo $durl $fname
    curl -O --output-dir $LOC/$lang $durl
end

function __check_zig_rel_data_ --argument c_ver -d "check zig"
    set -l n_ver (curl  -m 10 --connect-timeout 5  "https://ziglang.org/download/index.json" | jq -r ".master.version")
    set -l download_url (echo "$release_data" | jq --arg asset_name "$asset_name" -r '.master."x86_64-linux".tarball')
    __confirm_update__ "zig-bin" $c_ver $n_ver $download_url
end
