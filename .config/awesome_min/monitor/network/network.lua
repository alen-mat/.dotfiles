-- https://people.freedesktop.org/~lkundrak/nm-docs/gdbus-org.freedesktop.NetworkManager.html
-- https://lazka.github.io/pgi-docs/NM-1.0/
--https://lazka.github.io/pgi-docs/NM-1.0/classes/Client.html#NM.Client.check_connectivity_finish

local gtimer = require("gears.timer")
local gobject = require("gears.object")
local gdb = require("gears.debug")
local inspect = require("inspect")
local naughty = require("naughty")
local lgi = require("lgi")
local NM = lgi.require "NM"
local nm_client = NM.Client.new()
local Gio = lgi.Gio
local Glib = lgi.GLib

local network = {
	cstate = nil,
	obj = gobject {}
}
local bus = Gio.bus_get_sync(Gio.BusType.SYSTEM)

local function connection_state_notify(new_state, old_state, reason)
	local state = nm_client:check_connectivity()
	if network.cstate ~= state then
		network.cstate = state
		network.obj:emit_signal("Network::connstate", state)
	end
end

local function onDBusSignalCallback(conn, sender, object_path, interface_name, signal_name, param, user_data)
	local str = string.format("SIGNAL - object_path:%s, interface_name:%s, signal_name:%s, user_data : %s",
		object_path, interface_name, signal_name, tostring(#param))
	gdb.print_warning("network.lua::param " .. param[1] .. '    ' .. param[2] .. '    ' .. param[3])
	connection_state_notify(table.unpack(param))
end

local device_state_change_id = bus:signal_subscribe('org.freedesktop.NetworkManager',
	'org.freedesktop.NetworkManager.Device',
	'StateChanged', nil, nil, Gio.DBusSignalFlags.NONE, onDBusSignalCallback)


gtimer.delayed_call(function()
	network.obj:emit_signal("Network::connstate", nm_client:check_connectivity())
end)
return network
