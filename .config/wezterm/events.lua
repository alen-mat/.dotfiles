local wezterm = require('wezterm')

wezterm.on('update-right-status', function(window, pane)

	local name = window:active_key_table()
	if name then
		name = 'TABLE: ' .. name
	end
	window:set_right_status(wezterm.format {
		{ Foreground = { AnsiColor = 'Fuchsia' } },
		'ResetAttributes',
		{ Attribute = { Underline = 'Single' } },
		{ Text = "::" .. window:active_workspace() },
	})
end)


wezterm.on("open_in_vim", function(window, pane)
	local file = io.open("/tmp/wezterm_buf", "w")
	file:write(pane:get_lines_as_text(3000))
	file:close()
	window:perform_action(
		wezterm.action({
			SpawnCommandInNewTab = { args = { "nvim", "/tmp/wezterm_buf", "-c", "call cursor(3000,0)" } },
		}),
		pane
	)
end)


wezterm.on("open-uri", function(window, pane, uri)
	wezterm.log_info(window)
	wezterm.log_info(pane)
	wezterm.log_info(uri)
end)
