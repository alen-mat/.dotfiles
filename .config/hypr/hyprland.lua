require('env')
require('monitors')

hl.config({
  ecosystem = {
    enforce_permissions = true,
  },
})

hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")
require('rules')
hl.config({
  input = {
    kb_layout    = "us",
    kb_variant   = "",
    kb_model     = "",
    kb_options   = "",
    kb_rules     = "",

    follow_mouse = 0,

    sensitivity  = 0, -- -1.0 - 1.0, 0 means no modification.

    touchpad     = {
      natural_scroll = false,
    },
  },
})

hl.gesture({
  fingers = 4,
  direction = "horizontal",
  action = "workspace"
})

hl.config({
  general = {
    gaps_in          = 2,
    gaps_out         = 3,
    border_size      = 2,
    col              = {
      active_border   = {
        colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
      inactive_border = "rgba(595959aa)",
    },
    resize_on_border = false,
    allow_tearing    = false,
    layout           = "master",
  },

  decoration = {
    rounding         = 10,
    rounding_power   = 2,

    -- Change transparency of focused and unfocused windows
    active_opacity   = 1.0,
    inactive_opacity = 1.0,

    shadow           = {
      enabled      = true,
      range        = 4,
      render_power = 3,
      color        = 0xee1a1a1a,
    },

    blur             = {
      enabled  = true,
      size     = 3,
      passes   = 1,
      vibrancy = 0.1696,
    },
  },

  animations = {
    enabled = true,
  },
})


hl.config({
  dwindle = {
    preserve_split = true,
  },
  master = {
    new_status = "master",
  },
  scrolling = {
    fullscreen_on_one_column = true,
    column_width = 0.4
  },
})


hl.config({
  misc = {
    force_default_wallpaper = 0,
    disable_hyprland_logo   = true,
  },
})

hl.config({
  cursor = {
    hide_on_key_press = true,
    no_warps = true
  }
})



hl.on("hyprland.start", function()
  hl.exec_cmd('noctalia')
  hl.exec_cmd('hypridle')
  hl.exec_cmd('kanata -c ~/workspace/.dotfiles/.config/kanata/red_dragon_60.kbd')

  local monitors = hl.get_monitors()

  for _, monitor in ipairs(monitors) do
    for i = 1, 5 do
      hl.workspace_rule({ workspace = tostring(i), monitor = monitor.name, persistent = true })
    end
  end
end)
-- hl.on('window.urgent', function(win)
--   hl.notification.create({
--     text ='Window ' .. win..'  requires focus',
--     timeout = 1000,
--     icon = "ok",
--     color="#ff0000"
--   })
-- end)
hl.on('keybinds.submap', function(name)
  hl.notification.create({
    text = 'Submap ' .. (#name > 0 and name or 'Default'),
    timeout = 900,
    icon = "ok",
    color = "#90f066"
  })
end)

require('binds')
-- vim: ts=2 sts=2 sw=2 et
