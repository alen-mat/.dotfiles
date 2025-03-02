local awful   = require("awful")
local naughty = require("naughty")
local wibox   = require("wibox")
local gears   = require("gears")

local _data   = {
        devs = {},
        inet_active = false
}
local icons = {
        wifi ={
                ni = " 󱚵  ",
                i =  "   "
        },
        ethernet = {
                ni = " 󰈀  ",
                i = "   "
        }
}


local M       = {}
M.widget      = wibox.widget.textbox()
M.widget.text = "he"


local function refresh_devs()
        awful.spawn.easy_async("nmcli device", function(stdout)
                for line in stdout:gmatch("[^\r\n]+") do
                        if not line:match("^DEVICE") then
                                local intfc, type, status, name = line:match('(%S*)%s*(%S*)%s*(%S*)%s*(%S*)')
                                if type ~= "loopback" then
                                        table.insert(_data.devs[intfc], { type = type, status = status, name = name })
                                end
                        end
                end
        end)
end

local function check_inet()
        local bashcmd = [[
test=google.com
if nc -zw1 $test 443 && echo |openssl s_client -connect $test:443 2>&1 |awk '
  $1 == "SSL" && $2 == "handshake" { handshake = 1 }
  handshake && $1 == "Verification:" { ok = $2; exit }
  END { exit ok != "OK" }'
then
  echo "we have connectivity"
fi ]]
        awful.spawn.easy_async_with_shell(bashcmd, function(stdout)
                stdout = stdout:gsub("[\n\r]", "")
                if "we have connectivity" == stdout then
                        _data.inet_active = true
                        M.widget.text = icons.wifi.i
                else
                        if not _data.inet_active then
                                naughty.notify({ title = "Network", text = "Lost connectivity" })
                        end
                        _data.inet_active = false
                        M.widget.text = icons.wifi.ni
                end
        end)
end


function M:check_conn()
end

function M:init()
        gears.timer {
                timeout   = 5,
                call_now  = true,
                autostart = true,
                callback  = check_inet
        }
        gears.timer {
                timeout   = 30,
                call_now  = true,
                autostart = true,
                callback  = refresh_devs
        }
end

return M
