local wezterm = require('wezterm')

local config = {}
local font_names = { 'JetBrains Mono' }

config.default_prog = { '/bin/fish' } --{ '/bin/fish', '-l' }
config.color_scheme = 'tokyonight_night'
config.font = wezterm.font_with_fallback(font_names, { bold = true })
config.warn_about_missing_glyphs = false
config.font_size = 12
config.line_height = 1.0
config.dpi = 96.0
config.default_cursor_style = "BlinkingUnderline"
config.enable_wayland = true
config.bold_brightens_ansi_colors = true
-- Padding
config.window_padding = {
  left = 5,
  right = 5,
  top = 5,
  bottom = 5,
}

config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.show_tab_index_in_tab_bar = false
config.tab_bar_at_bottom = true
config.window_close_confirmation = "NeverPrompt"
config.disable_default_key_bindings = true
config.window_frame = {
  active_titlebar_bg = "#45475a",
  font = wezterm.font_with_fallback(font_names, { bold = true })
}

config.skip_close_confirmation_for_processes_named = {
  'bash',
  'sh',
  'zsh',
  'fish',
}

config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }
config.keys = {
  {
    key = "t",
    mods = "LEADER",
    action = wezterm.action { SpawnTab = "CurrentPaneDomain" }
  },
  {
    key = '|',
    mods = 'LEADER|SHIFT',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = "-",
    mods = "LEADER",
    action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" }
  },

  {
    key = "h",
    mods = "LEADER",
    action = wezterm.action { ActivatePaneDirection = "Left" }
  },
  {
    key = "j",
    mods = "LEADER",
    action = wezterm.action { ActivatePaneDirection = "Down" }
  },
  {
    key = "k",
    mods = "LEADER",
    action = wezterm.action { ActivatePaneDirection = "Up" }
  },
  {
    key = "l",
    mods = "LEADER",
    action = wezterm.action { ActivatePaneDirection = "Right" }
  },
  {
    key = "H",
    mods = "LEADER|SHIFT",
    action = wezterm.action { AdjustPaneSize = { "Left", 5 } }
  },
  {
    key = "J",
    mods = "LEADER|SHIFT",
    action = wezterm.action { AdjustPaneSize = { "Down", 5 } }
  },
  {
    key = "K",
    mods = "LEADER|SHIFT",
    action = wezterm.action { AdjustPaneSize = { "Up", 5 } }
  },
  {
    key = "L",
    mods = "LEADER|SHIFT",
    action = wezterm.action { AdjustPaneSize = { "Right", 5 } }
  },
  {
    key = "d",
    mods = "LEADER",
    action = wezterm.action { CloseCurrentPane = { confirm = true } }
  },
  {
    key = "s",
    mods = "LEADER",
    action = wezterm.action_callback(
      function(win, pane)
        local new_tab, _pane, new_win = win:mux_window():spawn_tab {
          args = { wezterm.home_dir .. '/.scripts/utils/cht.sh' },
          direction = "Right",
          size = 0.25,
          cwd = "$HOME",
        }
        new_tab:set_title("cht.sh!")
        --local fp = pane:split {
        --  args = { '$HOME/.scripts/utils/cht.sh' },
        --  direction = "Right",
        --  size = 0.25,
        --  cwd = "$HOME",
        --}
        --fp:inject_output '\r\n\x1b[3mhello there\r\n'
        --fp:send_text("btop\r")
      end)
  },
}

return config


-- vim: ts=2 sts=2 sw=2 et
