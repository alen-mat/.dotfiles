local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local naughty = require("naughty")
local dpi = require("beautiful").xresources.apply_dpi
local clickable_container = require("widgets.clickable-container")

local config_dir = gears.filesystem.get_configuration_dir()
local widget_icon_dir = config_dir .. "widgets/network/icons/"


local widget = wibox.widget {
	{
		id = "icon",
		image = widget_icon_dir .. "loading" .. ".svg",
		widget = wibox.widget.imagebox,
		resize = true,
	},
	layout = wibox.layout.align.horizontal,
}

local widget_button = wibox.widget {
	{
		widget,
		margins = dpi(3),
		widget = wibox.container.margin,
	},
	widget = clickable_container,
}

widget_button:buttons(gears.table.join(awful.button({}, 1, nil, function()
	awful.spawn("kitty --name Nmtui nmtui-connect", false)
end)))


local update_notify_no_access = true
local notify_no_access_quota = 0

local startup = true
local reconnect_startup = true
local notify_new_wifi_conn = false


local network_tooltip = awful.tooltip {
	text = "Loading...",
	objects = { widget_button },
	mode = "outside",
	align = "right",
	preferred_positions = { "left", "right", "top", "bottom" },
	margin_leftright = dpi(8),
	margin_topbottom = dpi(8),
}

local update_tooltip = function(message)
	network_tooltip:set_markup(message)
end

local check_internet_health = function()
	local command = [=[
	status_ping=0

	packets="$(ping -q -w2 -c2 1.1.1.1 | grep -o "100% packet loss")"
	if [ ! -z "${packets}" ];
	then
		status_ping=0
	else
		status_ping=1
	fi

	if [ $status_ping -eq 0 ];
	then
		echo 'Connected but no internet'
	fi
	]=]
	awful.spawn.easy_async_with_shell(command, function(stdout)
		local widget_icon_name = "wifi-strength"
		if not stdout:match "Connected but no internet" then
			if startup or reconnect_startup then
				awesome.emit_signal "system::network_connected"
			end
			widget_icon_name = "network"
			update_tooltip("<b>Connected</b>\n")
			--	update_wireless_data(wifi_strength_rounded, true)
		else
			widget_icon_name = widget_icon_name .. "-" .. tostring(4) .. "-alert"
			update_tooltip("<b>No internet!</b>\n")
			--	update_wireless_data(wifi_strength_rounded, false)
		end
		widget.icon:set_image(widget_icon_dir .. widget_icon_name .. ".svg")
	end)
end
local notify_connected = function(essid)
	local message = 'You are now connected to <b>"' .. essid .. '"</b>'
	local title = "Connection Established"
	local app_name = "System Notification"
	local icon = widget_icon_dir .. "wifi.svg"
	network_notify(message, title, app_name, icon)
end

-- Update tooltip


local network_notify = function(message, title, app_name, icon)
	if _G.network_noti_hack then
		naughty.notify {
			message = message,
			title = title,
			app_name = app_name,
			icon = icon,
		}
	end
	_G.network_noti_hack = not _G.network_noti_hack
end




gears.timer {
	timeout = 5,
	autostart = true,
	call_now = true,
	callback = check_internet_health,
}
return widget_button
