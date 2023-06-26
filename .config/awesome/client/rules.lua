local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local clientbuttons = require("client.buttons")
local clientkeys = require('client.keys')
local idea_rule = require('client.idea-rule')
-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
  -- All clients will match this rule.
  {
    rule = {},
    properties = {
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus = awful.client.focus.filter,
      raise = true,
      keys = clientkeys,
      buttons = clientbuttons,
      screen = awful.screen.preferred,
      placement = awful.placement.no_overlap + awful.placement.no_offscreen,
      titlebars_enabled = false
    }
  },

  -- Floating clients.
  {
    rule_any = {
      class = {
        "Gpick",
        "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
        "float",
        --"Zathura"
      },
      name = {
        "scrcpy-float", -- xev.
      },
    },
    properties = {
      floating = true,
      titlebars_enabled = false
    }
  },

  {
    rule_any = {
      instance = {
        "DTA",   -- Firefox addon DownThemAll.
        "copyq", -- Includes session name in class.
        "pinentry",
      },
      class = {
        "Arandr",
        "Blueman-manager",
        "Kruler",
        "MessageWin", -- kalarm.
        "Sxiv",
        "Wpa_gui",
        "veromix",
        "xtightvncviewer",
        "[Ss]potify",
        --"Zathura"
      },

      -- Note that the name property shown in xprop might be set slightly after creation of the client
      -- and the name shown there might not match defined rules here.
      name = {
        "Event Tester", -- xev.
      },
      role = {
        "AlarmWindow",   -- Thunderbird's calendar.
        "ConfigManager", -- Thunderbird's about:config.
        "pop-up",        -- e.g. Google Chrome's (detached) Developer Tools.
      }
    },
    properties = {
      floating = true,
      titlebars_enabled = true
    }
  },

  -- Add titlebars to normal clients and dialogs
  {
    rule_any = {
      type = { "dialog" }
    },
    properties = { titlebars_enabled = false }
  },

  { rule = { class = "Wifca", instance = "startup" }, properties = { tag = "9" } },
  { rule = { role = "_NET_WM_STATE_MAXIMIZED_VERT" }, properties = { titlebars_enabled = false } },
  { rule = { role = "_NET_WM_STATE_MAXIMIZED_HORZ" }, properties = { titlebars_enabled = false } },
  -- Set Firefox to always map on the tag named "2" on screen 1.
  -- { rule = { class = "Firefox" },
  --   properties = { screen = 1, tag = "2" } },
}

-- }}}
--
gears.table.join(awful.rules.rules,idea_rule)
