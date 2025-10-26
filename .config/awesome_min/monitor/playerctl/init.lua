local gobject = require("gears.object")
local naughty = require("naughty")
local M = {
    lgi = {},
    last_player_status = {}
}
function M:manage(name)
    print("New player appeared:", name)
    local player_instance = self.lgi._playerctl.Player.new_from_name(name)
    self.lgi._player_manager:manage_player(player_instance)
    self.last_player_status[player_instance.player_name] = {
        title = '',
        artist = '',
        artUrl = '',
        album = ''
    }
    player_instance.on_metadata = function(player, metadata)
        local data = metadata.value

        local title = data["xesam:title"] or ""
        local artist = data["xesam:artist"][1] or ""
        for i = 2, #data["xesam:artist"] do
            artist = artist .. ", " .. data["xesam:artist"][i]
        end
        local artUrl = data["mpris:artUrl"] or ""
        local album = data["xesam:album"] or ""
        local last_status = self.last_player_status[player_instance.player_name]
        if title ~= "" and last_status.title ~= title then
            local previous = naughty.action {
                name = "Previous"
            }
            local play_pause = naughty.action {
                name = "Play/Pause"
            }
            local next = naughty.action {
                name = "Next"
            }

            previous:connect_signal("invoked", function()
                player:previous()
            end)

            play_pause:connect_signal("invoked", function()
                player:play_pause()
            end)

            next:connect_signal("invoked", function()
                player:next()
            end)



            naughty.notification {
                -- app_icon = icons,
                -- app_name = app_name,
                -- font_icon = font_icon,
                -- icon = artUrl,
                title = title,
                text = artist,
                actions = { previous, play_pause, next },
                category =  "silent-notification"
            }
            last_status.title                                    = title
            last_status.artist                                   = artist
            last_status.artUrl                                   = artUrl
            last_status.album                                    = album
            self.last_player_status[player_instance.player_name] = last_status
        end
    end
end

function M:init()
    self.lgi._playerctl = require("lgi").Playerctl
    self.lgi._player_manager = self.lgi._playerctl.PlayerManager()
    for _, name in ipairs(self.lgi._player_manager.player_names) do
        self:manage(name)
    end
    function self.lgi._player_manager:on_name_appeared(name)
        self:manage(name)
    end

    function self.lgi._player_manager:on_name_vanished(name)
        print("Player vanished:", name)
    end
end

return M
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
