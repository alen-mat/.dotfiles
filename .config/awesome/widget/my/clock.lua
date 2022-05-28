local wibox = require('wibox')
local awful = require('awful')
local beautiful = require('beautiful')
local gears = require ("gears")
local naughty = require('naughty')
local dpi = beautiful.xresources.apply_dpi
local clickable_container = require ("widget.my.clickable-container")

local clock_widget = wibox.widget.textclock('<span font="' .. beautiful.font .. '">%d/%m %a %H:%M</span>')
clock_widget = wibox.widget {
		{
			clock_widget,
			margins = dpi(0),
			widget = wibox.container.margin,
		},
		widget = clickable_container,
}

clock_widget:connect_signal("mouse::enter", function()
		local w = mouse.current_wibox
		if w then
			old_cursor, old_wibox = w.cursor, w
			w.cursor = "hand1"
		end
end)

clock_widget:connect_signal("mouse::leave", function()
		if old_wibox then
			old_wibox.cursor = old_cursor
			old_wibox = nil
		end
end)

clock_tooltip = awful.tooltip {
		objects = { clock_widget },
		mode = "outside",
		delay_show = 1,
		preferred_positions = { "right", "left", "top", "bottom" },
		preferred_alignments = { "middle", "front", "back" },
		margin_leftright = dpi(8),
		margin_topbottom = dpi(8),
		timer_function = function()
			local ordinal = nil

			local day = os.date "%d"
			local month = os.date "%B"

			local first_digit = string.sub(day, 0, 1)
			local last_digit = string.sub(day, -1)

			if first_digit == "0" then
				day = last_digit
			end

			if last_digit == "1" and day ~= "11" then
				ordinal = "st"
			elseif last_digit == "2" and day ~= "12" then
				ordinal = "nd"
			elseif last_digit == "3" and day ~= "13" then
				ordinal = "rd"
			else
				ordinal = "th"
			end

			local date_str = "Today is the "
				.. "<b>"
				.. day
				.. ordinal
				.. " of "
				.. month
				.. "</b>.\n"
				.. "And it's "
				.. os.date "%A"

			return date_str
		end,
}

clock_widget:connect_signal("button::press", function(self, lx, ly, button)
		-- Hide the tooltip when you press the clock widget
		if clock_tooltip.visible and button == 1 then
			clock_tooltip.visible = false
		end
end)

month_calendar = awful.widget.calendar_popup.month {
		start_sunday = false,
		spacing = dpi(5),
		font = beautiful.font,
		long_weekdays = true,
		margin = dpi(5),
		style_month = {
			border_width = dpi(0),
			bg_color = beautiful.background,
			padding = dpi(20),
			shape = function(cr, width, height)
				gears.shape.partially_rounded_rect(cr, width, height, true, true, true, true, beautiful.groups_radius)
			end,
		},
		style_header = {
			border_width = 0,
			bg_color = beautiful.transparent,
		},
		style_weekday = {
			border_width = 0,
			bg_color = beautiful.transparent,
		},
		style_normal = {
			border_width = 0,
			bg_color = beautiful.transparent,
		},
		style_focus = {
			border_width = dpi(0),
			border_color = beautiful.fg_normal,
			bg_color = beautiful.accent,
			shape = function(cr, width, height)
				gears.shape.partially_rounded_rect(cr, width, height, true, true, true, true, dpi(4))
			end,
		},
}

month_calendar:attach(clock_widget, "tr", {
		on_pressed = true,
		on_hover = false,
})


return clock_widget
