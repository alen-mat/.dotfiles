local wezterm = require('wezterm')

_GT = {
  -- color_scheme = 'tokyonight_night'
  color_scheme = '3024 Night'
}

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.enable_wayland = false ----os.getenv("XDG_SESSION_TYPE") == "wayland" -- default true

local font_names = {
  { family = 'Wumpus Mono Pro', weight = 'Regular', scale = 1.1 },
  'JetBrains Mono',
  'Anonymous Pro'
}

if wezterm.target_triple:find("windows") then
  config.default_prog = { "pwsh" }
else
  config.default_prog = { '/bin/fish' } --{ '/bin/fish', '-l' }
end

config.color_scheme = _GT.color_scheme
-- config.font = wezterm.font_with_fallback(font_names, { bold = false })
config.warn_about_missing_glyphs = false
config.font_size = 12
-- config.line_height = 1.0
-- config.dpi = 96.0
config.bold_brightens_ansi_colors = "BrightAndBold"
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.window_decorations = "RESIZE"
config.colors = {}
config.colors.tab_bar = {}
config.colors.tab_bar.background = '#000000'
config.show_new_tab_button_in_tab_bar = false


config.window_background_opacity = 0.7
-- Padding
config.window_padding = {
  left = 5,
  right = 5,
  top = 5,
  bottom = 5,
}

config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.show_tab_index_in_tab_bar = false

config.window_close_confirmation = "NeverPrompt"
config.disable_default_key_bindings = true
config.window_frame = {
  active_titlebar_bg = "#45475a",
  font = wezterm.font { family = 'Roboto', weight = 'Bold' },
  font_size = 8.0,
}

-- config.window_content_alignment = {
--   horizontal = 'Center',
--   vertical = 'Center',
-- }
config.skip_close_confirmation_for_processes_named = {
  'bash',
  'sh',
  'zsh',
  'fish',
}

config.window_padding = {
  left = 0,
  right = 0,
  top =0,
  bottom = 0,
}

-- local wmod = wezterm.target_triple:find("windows") and "SHIFT|CTRL" or "SHIFT|SUPER"
config.leader = { key = 'b', mods = 'CTRL', timeout_milliseconds = 1001 }
config.keys = require("keys")
require("events")

return config


-- vim: ts=2 sts=2 sw=2 et
