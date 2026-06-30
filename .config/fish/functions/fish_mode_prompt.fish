function fish_mode_prompt
  set -l vimode
  set -l modecolor
  if contains -- --final-rendering $argv
  else
    switch $fish_bind_mode
      case default
        set modecolor (set_color --bold red)
        set vimode '[N] '
      case insert
        set modecolor (set_color --bold green)
        set vimode '[I] '
      case replace_one
        set modecolor (set_color --bold green)
        set vimode '[R] '
      case replace
        set modecolor (set_color --bold bryellow)
        set vimode '[R] '
      case visual
        set modecolor (set_color --bold brmagenta)
        set vimode '[V] '
      case operator f F t T
        set modecolor (set_color --bold cyan)
        set vimode '[N] '
      case '*'
        set modecolor (set_color --bold red)
        set vimode '[?] '
    end
  end
  set_color --reset
  string join '' -- $modecolor $vimode
end
