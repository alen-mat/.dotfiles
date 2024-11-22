local awful   = require("awful")
local wibox   = require("wibox")
local watch   = require("awful.widget.watch")
local naughty = require("naughty")

function string:endswith(ending)
    return ending == "" or self:sub(- #ending) == ending
end

local volume_glyph       = "󰓃"

local M                  = {}
M.volume_widget          = wibox.widget.textbox()
M.widget_text            = {
    on  = volume_glyph .. ' % 3d%% ',
    off = '󰓄% 3dM ',
}
M.volume_tooltip         = awful.tooltip({
    objects = { M.volume_widget },
    mode = "outside",
    align = "left",
    referred_positions = { "right", "left", "top", "bottom" }
})
local init_default_audio = function()
    local default_audio = { 'wpctl', 'get-volume', '@DEFAULT_AUDIO_SINK@' }
    watch(default_audio, 10, function(widget, std_out)
        local vol = string.match(std_out, 'Volume: ([%d]*[.][%d]+)')
        local state = std_out:endswith('[MUTED]') and 'off' or 'on'
        M:update_widget({ state = state, volume = tonumber(vol) * 100 })
        awful.spawn.easy_async_with_shell(
            [[wpctl inspect  @DEFAULT_AUDIO_SINK@ | grep -e 'node.description' -e 'device.api' ]],
            function(stdout)
                for s in stdout:gmatch("[^\r\n]+") do
                    local key, value = s:match('(.+) = "(.+)"')
                    key = key:match("^%s*(.-)%s*$")
                    value = value:match("^%s*(.-)%s*$")
                    if key == "device.api" then
                        if value == 'bluez5' then
                            volume_glyph = "󰦢"
                        else
                            volume_glyph = "󰓃"
                        end
                    elseif key == "* node.description" then
                        M.volume_tooltip.text = value
                    end
                end
            end)
    end
    )
end

function M:setup(args)
    init_default_audio()
end

function M:update_widget(setting)
    self.volume_widget:set_markup(
        self.widget_text[setting.state]:format(setting.volume))
end

function M:inc_volume()
    awful.spawn("wpctl set-volume  @DEFAULT_AUDIO_SINK@ 3%+", false)
end

function M:dec_volume()
    awful.spawn("wpctl set-volume  @DEFAULT_AUDIO_SINK@ 2%-", false)
end

function M:mute_defaut_sink()
    awful.spawn("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle", false)
end

return M
