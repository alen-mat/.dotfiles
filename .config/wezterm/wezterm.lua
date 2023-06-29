local wezterm = require('wezterm')
local config = {}
local font_names = {'JetBrains Mono'}

config.default_prog = { '/bin/fish', '-l' }
config.color_scheme = 'Batman'
config.font = wezterm.font_with_fallback(font_names, { bold = true })
config.warn_about_missing_glyphs = false
config.font_size = 12
config.line_height = 1.0
config.dpi = 96.0
config.default_cursor_style = "BlinkingUnderline"

config.bold_brightens_ansi_colors = true
-- Padding
config.window_padding = {
	left = 25,
	right = 25,
	top = 25,
	bottom = 25,
}

config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.show_tab_index_in_tab_bar = false
config.tab_bar_at_bottom = true
config.window_close_confirmation = "NeverPrompt"
config.disable_default_key_bindings = true
config.window_frame = { active_titlebar_bg = "#45475a", font = wezterm.font_with_fallback(font_names, { bold = true }) }
return config
