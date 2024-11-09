local wezterm = require('wezterm')

_GT = {
  -- color_scheme = 'tokyonight_night'
  color_scheme = 'Tomorrow Night Burns'
}

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

local font_names = {
  { family = 'Wumpus Mono Pro', weight = 'Regular', scale = 1.1 }
  , 'JetBrains Mono', "Anonymous Pro" }

config.default_prog = { '/bin/fish' } --{ '/bin/fish', '-l' }
config.color_scheme = _GT.color_scheme
-- config.font = wezterm.font_with_fallback(font_names, { bold = false })
config.warn_about_missing_glyphs = false
config.font_size = 12
config.line_height = 1.0
config.dpi = 96.0
config.default_cursor_style = "BlinkingUnderline"
config.enable_wayland = true
config.bold_brightens_ansi_colors = "BrightAndBold"

config.window_background_opacity = 0.9
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
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false

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

config.leader = { key = 'b', mods = 'CTRL', timeout_milliseconds = 1001 }
config.keys = require("keys")
require("tabbar")
--local graphics = require("graphics")
--config.webgpu_preferred_adapter = graphics.webgpu_preferred_adapter
--config.front_end = graphics.front_end
--config.webgpu_power_preference = graphics.webgpu_power_preference
require("events")

return config


-- vim: ts=2 sts=2 sw=2 et
