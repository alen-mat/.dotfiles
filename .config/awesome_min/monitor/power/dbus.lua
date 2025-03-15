-- https://github.com/berlam/awesome-upower-battery/
--
local gobject = require("gears.object")

local UPowerGlib = require("lgi").require "UPowerGlib"

local UPower = {
   obj = gobject {}
}

UPower.status = {
   [UPowerGlib.DeviceState.PENDING_DISCHARGE] = "Discharging",
   [UPowerGlib.DeviceState.PENDING_CHARGE]    = "Charging",
   [UPowerGlib.DeviceState.FULLY_CHARGED]     = "Full",
   [UPowerGlib.DeviceState.EMPTY]             = "N/A",
   [UPowerGlib.DeviceState.DISCHARGING]       = "Discharging",
   [UPowerGlib.DeviceState.CHARGING]          = "Charging",
   [UPowerGlib.DeviceState.UNKNOWN]           = "N/A"
}

UPower.kind = {
   [UPowerGlib.DeviceKind.UNKNOWN]      = "N/A",
   [UPowerGlib.DeviceKind.LINE_POWER]   = 1,
   [UPowerGlib.DeviceKind.TABLET]       = "N/A",
   [UPowerGlib.DeviceKind.COMPUTER]     = "N/A",
   [UPowerGlib.DeviceKind.LAST]         = "N/A",
   [UPowerGlib.DeviceKind.BATTERY]      = 0,
   [UPowerGlib.DeviceKind.UPS]          = "N/A",
   [UPowerGlib.DeviceKind.MONITOR]      = "N/A",
   [UPowerGlib.DeviceKind.MOUSE]        = "N/A",
   [UPowerGlib.DeviceKind.KEYBOARD]     = "N/A",
   [UPowerGlib.DeviceKind.PDA]          = "N/A",
   [UPowerGlib.DeviceKind.PHONE]        = "N/A",
   [UPowerGlib.DeviceKind.MEDIA_PLAYER] = "N/A"
}

function UPower.toClock(seconds)
   if seconds <= 0 then
      return "00:00:00";
   else
      local hours = string.format("%02.f", math.floor(seconds / 3600));
      local mins = string.format("%02.f", math.floor(seconds / 60 - (hours * 60)));
      local secs = string.format("%02.f", math.floor(seconds - hours * 3600 - mins * 60));
      return hours .. ":" .. mins .. ":" .. secs
   end
end

function UPower:init()
   UPower.display_device = UPowerGlib.Client():get_display_device()
   UPower.display_device.on_notify = function(device)
      local data = {}
      data.status = UPower.status[device.state]
      data.ac_status = UPower.kind[device.kind]
      data.perc = 0 + device.percentage
      data.watt = device.energy_full_design
      if data.status == "Charging" then
         data.time = UPower.toClock(device.time_to_full)
      elseif data.status == "Discharging" then
         data.time = UPower.toClock(device.time_to_empty)
      else
         data.time = "N/A"
      end
      UPower.obj:emit_signal("upower::update",device, data)
   end
end

return UPower
