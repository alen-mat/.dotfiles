local awful     = require("awful")
local naughty   = require("naughty")
local wibox     = require("wibox")
local gears     = require("gears")
local nwmonitor = require('monitor.network.network')
local dpi       = require("beautiful").xresources.apply_dpi

local _data     = {
        devs = {},
        inet_active = false
}
local icons     = {
        wifi = {
                ni = " 󱚵  ",
                i = "   "
        },
        ethernet = {
                ni = " 󰈀  ",
                i = "   "
        }
}


local M         = {}
M.widget        = wibox.widget {
        align  = 'center',
        valign = 'center',
        widget = wibox.widget.textbox,
        font   = "Iosevka " .. dpi(12)
}

M.widget.text   = "he"

M.network_popup = awful.tooltip({
        objects = { M.widget },
        mode = "outside",
        align = "left",
        referred_positions = { "right", "left", "top", "bottom" }
})


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
                collectgarbage()
        end)
end

nwmonitor.obj:connect_signal("Network::connstate", function(self, state)
        local text = ''
        local category = 'network.error'
        M.network_popup.text = state
        if state == 'FULL' then
                M.widget.text = icons.wifi.i
                category = 'network.connected'
                text = "We are back"
        else
                M.widget.text = icons.wifi.ni
                category = 'network.disconnected'
                text = "Lost connectivity"
        end
        naughty.notify({ title = "Network", text = text, category = category })
end)
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
                stdout             = stdout:gsub("[\n\r]", "")
                local is_connected = "we have connectivity" == stdout
                local text         = ""
                if is_connected then
                        M.widget.text = icons.wifi.i
                        text = "We are back"
                else
                        M.widget.text = icons.wifi.ni
                        text = "Lost connectivity"
                end
                if _data.inet_active ~= is_connected then
                        naughty.notify({ title = "Network", text = text })
                end
                _data.inet_active = is_connected
        end)
        collectgarbage()
end


function M:check_conn()
end

function M:init()
end

return M
