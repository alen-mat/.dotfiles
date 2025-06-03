local gears = require('gears')
local focus_line_style = {
	line  = { width = 3, dx = 30, dy = 20, subwidth = 6 },
	border = { width = 8 },
	color = { gray = "#404040", main = "#025A73", wibox = "#202020" },
}

local function focus_line(c, style, is_horizontal)
	-- build widget
	local widg = wibox.widget.base.make_widget()
	widg._style = redutil.table.merge(focus_line_style, style or {})
	widg._data = { color = widg._style.color.gray }

	-- widget setup
	function widg:fit(_, _, width, height)
		return width, height
	end

	function widg:draw(_, cr, width, height)
		local dy = self._style.line.subwidth - self._style.line.width
		local dw = is_horizontal and self._style.line.dx or self._style.line.dy

		cr:set_source(gears.color(self._style.color.wibox))
		cr:rectangle(0, height, width, -self._style.border.width)
		cr:fill()

		cr:set_source(gears.color(self._data.color))
		cr:rectangle(0, dy, width, self._style.line.width)
		cr:fill()

		cr:rectangle(0, 0, dw, self._style.line.subwidth)
		cr:rectangle(width, 0, -dw, self._style.line.subwidth)
		if is_horizontal then
			cr:rectangle(0, 0, self._style.line.subwidth, height)
			cr:rectangle(width, 0, -self._style.line.subwidth, height)
		end
		cr:fill()
	end

	-- user function
	function widg:set_active(active)
		self._data.color = active and self._style.color.main or self._style.color.gray
		self:emit_signal("widget::redraw_needed")
	end

	-- connect focus signal
	c:connect_signal("focus", function() widg:set_active(true) end)
	c:connect_signal("unfocus", function() widg:set_active(false) end)

	return widg
end
