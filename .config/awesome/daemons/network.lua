local naughty = require('naughty')
local awful = require("awful")

local function trim(s)
  return s:find '^%s*$' and '' or s:match '^%s*(.*%S)'
end

local interfaces = {
}

local function update_status()
  local bat = 'BAT1'
  local f_capacity = assert(io.open("/sys/class/power_supply/BAT1/capacity", "r"))
  local f_status = assert(io.open("/sys/class/power_supply/BAT1/status", "r"))

  local bat_capacity = tonumber(f_capacity:read("*all"))
  local bat_status = trim(f_status:read("*all"))

  if Current_bat_state ~= bat_status then
    naughty.notify({
      title = "Battery updated"
      ,
      text = "battery " .. bat_status
      ,
      fg = "#ff0000"
      ,
      bg = "#deb887"
      ,
      timeout = 15
      ,
      position = "top_left"
    })
    Current_bat_state = bat_status
  end

  if ((bat_capacity <= 18 or bat_capacity == 25) and bat_status == "Discharging") then
    naughty.notify({
      title = "battery warning"
      ,
      text = "battery low! " .. bat_capacity .. "%" .. " left!"
      ,
      fg = "#ff0000"
      ,
      bg = "#deb887"
      ,
      timeout = 15
      ,
      position = "top_left"
    })
  elseif (bat_capacity >= 85 and bat_status == "Charging") then
    naughty.notify({
      title = "battery warning"
      ,
      text = "battery charged! " .. bat_capacity .. "%"
      ,
      fg = "#ff0000"
      ,
      bg = "#deb887"
      ,
      timeout = 15
      ,
      position = "top_left"
    })
  end
  awesome.emit_signal("daemon::network", bat_status, bat_capacity, bat)
end

local function enumerate_networks()
  awful.spawn.easy_async_with_shell([=[
      nmcli device status
  ]=], function(stdout)

for line in stdout:gmatch("([^\n]*)\n?") do
    naughty.notify({
      title = "battery warning"
      ,
      text = line
      ,
      fg = "#ff0000"
      ,
      bg = "#deb887"
      ,
      timeout = 15
      ,
      position = "top_left"
    })
end

  end)
end

enumerate_networks()
--update_status()
--local timer = timer({ timeout = 8 })
--timer:connect_signal("timeout", update_status)
--timer:start()
