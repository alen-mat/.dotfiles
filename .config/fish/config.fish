set -g fish_key_bindings fish_vi_key_bindings
set -g fish_greeting ""
if status is-interactive
# Commands to run in interactive sessions can go here
end
$HOME/.local/bin/mise activate fish | source
