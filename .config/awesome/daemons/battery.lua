local naughty = require('naughty')

local function trim(s)
  return s:find '^%s*$' and '' or s:match '^%s*(.*%S)'
end

Current_bat_state = ''
local function bat_notification()
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
  awesome.emit_signal("daemon::battery", bat_status, bat_capacity, bat)
end


bat_notification()
local battimer = timer({ timeout = 30 })
battimer:connect_signal("timeout", bat_notification)
battimer:start()
