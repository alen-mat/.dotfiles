local wezterm = require('wezterm')

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
table.insert(keys, { key = 'p', mods = 'LEADER', action = wezterm.action { ActivateTabRelative = -1 } })
table.insert(keys, { key = 'n', mods = 'LEADER', action = wezterm.action { ActivateTabRelative = 1 } })
table.insert(keys, { key = 'p', mods = 'LEADER|SHIFT', action = wezterm.action { MoveTabRelative = -1 } })
table.insert(keys, { key = 'n', mods = 'LEADER|SHIFT', action = wezterm.action { MoveTabRelative = 1 } })
table.insert(keys, { key = 'z', mods = 'LEADER', action = wezterm.action.TogglePaneZoomState, });

table.insert(keys, { key = "e", mods = "LEADER", action = wezterm.action({ EmitEvent = "open_in_vim" }) })
----------need to tinker with this ----------
table.insert(keys, {
  key = 'S',
  mods = 'CTRL|SHIFT',
  action = wezterm.action_callback(
    function(window, pane)
      local home = wezterm.home_dir
      local workspaces = {
        { id = home,                label = 'Home' },
        { id = home .. '/work',     label = 'Work' },
        { id = home .. '/personal', label = 'Personal' },
        { id = home .. '/.config',  label = 'Config' },
      }

      window:perform_action(
        wezterm.action.InputSelector {
          action = wezterm.action_callback(
            function(inner_window, inner_pane, id, label)
              if not id and not label then
                wezterm.log_info 'cancelled'
              else
                wezterm.log_info('id = ' .. id)
                wezterm.log_info('label = ' .. label)
                inner_window:perform_action(
                  wezterm.action.SwitchToWorkspace {
                    name = label,
                    spawn = {
                      label = 'Workspace: ' .. label,
                      cwd = id,
                    },
                  },
                  inner_pane
                )
              end
            end
          ),
          title = 'Choose Workspace',
          choices = workspaces,
          fuzzy = true,
          fuzzy_description = 'Fuzzy find and/or make a workspace',
        },
        pane
      )
    end),
})

return keys
