-- [[@as Wezterm]]
local wezterm = require('wezterm')
local sessionizer = require("sessionizer")

local keys = {
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
    key = "Backspace",
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
      end)
  },
}
table.insert(keys, { key = 'p', mods = 'LEADER', action = wezterm.action { ActivateTabRelative = -1 } })
table.insert(keys, { key = 'n', mods = 'LEADER', action = wezterm.action { ActivateTabRelative = 1 } })
table.insert(keys, { key = 'p', mods = 'LEADER|SHIFT', action = wezterm.action { MoveTabRelative = -1 } })
table.insert(keys, { key = 'n', mods = 'LEADER|SHIFT', action = wezterm.action { MoveTabRelative = 1 } })
table.insert(keys, { key = 'z', mods = 'LEADER', action = wezterm.action.TogglePaneZoomState, })

table.insert(keys, { key = 'a', mods = 'LEADER', action = wezterm.action.ShowLauncher })
table.insert(keys, { key = 'L', mods = 'CTRL', action = wezterm.action.ShowDebugOverlay })

table.insert(keys, {
  key = 'b',
  mods = 'LEADER|CTRL',
  action = wezterm.action.ShowLauncherArgs {
    flags = 'FUZZY|WORKSPACES',
  },
})

table.insert(keys, { key = "e", mods = "LEADER", action = wezterm.action({ EmitEvent = "open_in_vim" }) })

table.insert(keys, { key = 'PageUp', mods = '', action = wezterm.action.ScrollByPage(-1) })
table.insert(keys, { key = 'PageDown', mods = '', action = wezterm.action.ScrollByPage(1) })
table.insert(keys, { key = 'PageUp', mods = 'CTRL', action = wezterm.action.ScrollByLine(-1) })
table.insert(keys, { key = 'PageDown', mods = 'CTRL', action = wezterm.action.ScrollByLine(1) })
----------need to tinker with this ----------
table.insert(keys, { key = "f", mods = "LEADER", action = wezterm.action_callback(sessionizer.toggle) })

return keys
