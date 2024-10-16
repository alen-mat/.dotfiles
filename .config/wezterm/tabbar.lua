local wezterm = require('wezterm')

local scheme = wezterm.get_builtin_color_schemes()[_GT.color_scheme]

local solid_left_arrow = wezterm.nerdfonts.pl_right_hard_divider
local solid_right_arrow = wezterm.nerdfonts.pl_left_hard_divider

local function basename(s)
  return string.gsub(s, '(.*[/\\])(.*)', '%2')
end

wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  local pane = tab.active_pane
  local title = basename(pane.foreground_process_name)
      .. ' '
      .. pane.pane_id
  -- https://github.com/wez/wezterm/issues/807
  -- local edge_background = scheme.background
  -- https://github.com/wez/wezterm/blob/61f01f6ed75a04d40af9ea49aa0afe91f08cb6bd/config/src/color.rs#L245
  local edge_background = "#2e3440"
  local background = scheme.ansi[1]
  local foreground = scheme.ansi[5]

  if tab.is_active then
    background = scheme.brights[1]
    foreground = scheme.brights[8]
  elseif hover then
    background = scheme.cursor_bg
    foreground = scheme.cursor_fg
  end
  local edge_foreground = background

  return {
    { Attribute = { Intensity = "Bold" } },
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = ' ' },
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = title },
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = ' ' },
    { Attribute = { Intensity = "Normal" } },
  }
end
)
