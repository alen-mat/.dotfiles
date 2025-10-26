local awful = require("awful")
local naughty = require("naughty")
local M = {}
function M:toggle()
	if self.is_running then
		root.keys(self.globalkeys)
		naughty.notification {
			message = "Passthrough mode : disabled."
		}
	else
		root.keys(self.passthough_bindings)
		naughty.notification {
			message = "Passthrough mode : enabled."
		}
	end
	self.is_running = not self.is_running
end

function M:init(root_keys)
	M.globalkeys = root_keys
	M.passthough_bindings = {
		awful.key({ 'Mod4' }, "Pause", function() self:toggle() end,
			{ description = "Send keys to active client", group = "Util" }),
		awful.key({
			{ 'Mod4' }, "Tab", awful.tag.history.restore,
			{ description = "Swith to previos tag by history", group = "Tag navigation" } }),
	}
end

return M
