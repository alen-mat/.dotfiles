local gobject = require("gears.object")

local NM = require("lgi").require "NM"

local network = {}
local access_point = {}
local instance = nil

network.NMState = {
	UNKNOWN = 0, -- Networking state is unknown. This indicates a daemon error that
	-- makes it unable to reasonably assess the state. In such event the applications
	-- are expected to assume Internet connectivity might be present and not disable
	-- controls that require network access. The graphical shells may hide the network
	-- accessibility indicator altogether since no meaningful status indication can be provided.
	ASLEEP = 10, -- Networking is not enabled, the system is being suspended or resumed from suspend.
	DISCONNECTED = 20, -- There is no active network connection. The graphical
	-- shell should indicate no network connectivity and the applications
	-- should not attempt to access the network.
	DISCONNECTING = 30, -- Network connections are being cleaned up.
	-- The applications should tear down their network sessions.
	CONNECTING = 40, -- A network connection is being started The graphical
	-- shell should indicate the network is being connected while the
	-- applications should still make no attempts to connect the network.
	CONNECTED_LOCAL = 50, -- There is only local IPv4 and/or IPv6 connectivity,
	-- but no default route to access the Internet. The graphical
	-- shell should indicate no network connectivity.
	CONNECTED_SITE = 60, -- There is only site-wide IPv4 and/or IPv6 connectivity.
	-- This means a default route is available, but the Internet connectivity check
	-- (see "Connectivity" property) did not succeed. The graphical shell
	-- should indicate limited network connectivity.
	CONNECTED_GLOBAL = 70, -- There is global IPv4 and/or IPv6 Internet connectivity
	-- This means the Internet connectivity check succeeded, the graphical shell should
	-- indicate full network connectivity.
}

network.DeviceType = {
	ETHERNET = 1,
	WIFI = 2,
}

network.DeviceState = {
	UNKNOWN = 0, -- the device's state is unknown
	UNMANAGED = 10, -- the device is recognized, but not managed by NetworkManager
	UNAVAILABLE = 20, -- the device is managed by NetworkManager,
	-- but is not available for use. Reasons may include the wireless switched off,
	-- missing firmware, no ethernet carrier, missing supplicant or modem manager, etc.
	DISCONNECTED = 30, -- the device can be activated,
	-- but is currently idle and not connected to a network.
	PREPARE = 40, -- the device is preparing the connection to the network.
	-- This may include operations like changing the MAC address,
	-- setting physical link properties, and anything else required
	-- to connect to the requested network.
	CONFIG = 50, -- the device is connecting to the requested network.
	-- This may include operations like associating with the Wi-Fi AP,
	-- dialing the modem, connecting to the remote Bluetooth device, etc.
	NEED_AUTH = 60, -- the device requires more information to continue
	-- connecting to the requested network. This includes secrets like WiFi passphrases,
	-- login passwords, PIN codes, etc.
	IP_CONFIG = 70, -- the device is requesting IPv4 and/or IPv6 addresses
	-- and routing information from the network.
	IP_CHECK = 80, -- the device is checking whether further action
	-- is required for the requested network connection.
	-- This may include checking whether only local network access is available,
	-- whether a captive portal is blocking access to the Internet, etc.
	SECONDARIES = 90, -- the device is waiting for a secondary connection
	-- (like a VPN) which must activated before the device can be activated
	ACTIVATED = 100, -- the device has a network connection, either local or global.
	DEACTIVATING = 110, -- a disconnection from the current network connection
	-- was requested, and the device is cleaning up resources used for that connection.
	-- The network connection may still be valid.
	FAILED = 120, -- the device failed to connect to
	-- the requested network and is cleaning up the connection request
}
