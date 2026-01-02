if status is-interactive
    # Commands to run in interactive sessions can go here
end

# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
test -r "$HOME/.opam/opam-init/init.fish" && source "$HOME/.opam/opam-init/init.fish" > /dev/null 2> /dev/null; or true
# END opam configuration
test -r "$HOME/.config/fish/editor.fish" && source "$HOME/.config/fish/editor.fish" > /dev/null 2> /dev/null; or true
