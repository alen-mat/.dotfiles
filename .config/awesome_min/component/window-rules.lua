local ruled = require("ruled")
local awful = require("awful")
local naughty = require("naughty")
local beautiful = require("beautiful")

ruled.client.connect_signal("request::rules", function()
    ruled.client.append_rule {
        id         = "global",
        rule       = {},
        properties = {
            border_width      = beautiful.border_width,
            border_color      = beautiful.border_normal,
            focus             = awful.client.focus.filter,
            titlebars_enabled = true,
            raise             = true,
            -- size_hints_honor     = false,
            screen            = awful.screen.preferred,
            placement         = awful.placement.no_overlap + awful.placement.no_offscreen,
        },
    }

    ruled.client.append_rule {
        id         = 'round_clients',
        rule_any   = {
            type = {
                'normal',
                'dialog'
            }
        },
        except_any = {
            name = { 'Discord Updater' }
        },
        properties = {
            round_corners = true,
            shape = beautiful.client_shape_rounded
        }
    }

    ruled.client.append_rule {
        id         = "floating",
        rule_any   = {
            instance = { "copyq", "pinentry" },
            class    = {
                "Arandr", "Blueman-manager", "Gpick", "Kruler", "Sxiv",
                "Tor Browser", "Wpa_gui", "veromix", "xtightvncviewer"
            },
            name     = {
                "Event Tester", -- xev.
            },
            role     = {
                "AlarmWindow",   -- Thunderbird's calendar.
                "ConfigManager", -- Thunderbird's about:config.
                "pop-up",        -- e.g. Google Chrome's (detached) Developer Tools.
                'dialog',
                'splash'
            }
        },
        properties = {
            floating  = true,
            placement = awful.placement.centered + awful.placement.no_overlap + awful.placement.no_offscreen,
        }
    }


    ruled.client.append_rule {
        id         = 'titlebars',
        rule_any   = {
            type = {
                'dialog',
                'modal',
                'utility',
                'splash'
            }
        },
        properties = {
            titlebars_enabled = true
        }
    }

    ruled.client.append_rule {
        rule_any   = { type = { "normal" } },
        properties = { placement = awful.placement.no_overlap + awful.placement.no_offscreen }
    }

    ruled.client.append_rule {
        id         = 'no-titlebars-float',
        rule_any   = {
            class = {
                "Gpick",
                "Tor Browser",
                "float",
            },
            name = {
                "scrcpy-float",
                "Picture-in-Picture",
            },
        },
        properties = {
            floating = true,
            ontop = true,
        }
    }
    ruled.client.append_rule {
        id         = 'no-titlebars-float-sticky',
        rule_any   = {
            name = {
                "Picture-in-Picture",
            },
        },
        properties = {
            floating = true,
            ontop = true,
            sticky = true
        }
    }

    ruled.client.append_rule {
        id         = 'zooom',
        rule       = {
            class = "[Zz]oom",
        },
        properties = {
            floating = true,
            ontop = true,
            tag = "9",
        }
    }

    ruled.client.append_rule {
        id = "splash screen fix",
        rule_any = { class = { "jetbrains-%w+", "java-lang-Thread" } },
        callback = function(jetbrains)
            if jetbrains.skip_taskbar then jetbrains.floating = true end
        end
    }
    ruled.client.append_rule {
        rule = {
            class = "jetbrains-.*",
        }, properties = { focus = true, } -- buttons = clientbuttons_jetbrains }
    }
    ruled.client.append_rule {
        rule = {
            class = "jetbrains-.*",
            name = "win.*"
        }, properties = { titlebars_enabled = false, focusable = false, focus = true, floating = true, placement = awful.placement.restore }
    }

    ruled.client.append_rule {
        id = "spotify",
        rule = { class = "[Ss]potify" },
        properties = {
            floating = true,
            ontop = true,
            tag = "6",
        },
        callback = function(client)
            client:geometry({ width = 1038, height = 622 })
            local app = function(c)
                return ruled.client.match(c, { class = 'Spotify' })
            end

            local app_count = 0
            for _ in awful.client.iterate(app) do
                app_count = app_count + 1
            end

            if app_count > 1 then
                client:kill()
                for c in awful.client.iterate(app) do
                    c:jump_to(false)
                end
            end
        end
    }

    ruled.client.append_rule {
        id = "tg-client",
        rule = { class = "TelegramDesktop" },
        properties = {
            floating = true,
            ontop = true,
            tag = "6",
        },
        callback = function(client)
            client:geometry({ width = 100, height = 1200 })
            local app = function(c)
                return ruled.client.match(c, { class = 'TelegramDesktop' })
            end

            local app_count = 0
            for _ in awful.client.iterate(app) do
                app_count = app_count + 1
            end

            if app_count > 1 then
                client:kill()
                for c in awful.client.iterate(app) do
                    c:jump_to(false)
                end
            end
        end
    }

    ruled.client.append_rule {
        id         = "zen-fire",
        rule       = { class = { "Firefox", "zen" } },
        properties = { screen = 1, tag = "2" }
    }
    ruled.client.append_rule {
        id         = "citrix",
        rule       = { class = { "[Ww]fica" } },
        properties = { screen = 1, tag = "4" }
    }

    ruled.client.append_rule {
        id         = 'skype-video-popup',
        rule       = {
            class = "Skype",
            name  = "Skype",
            role  = "browser-window"
        },
        properties = {
            floating = true,
            ontop = true,
            sticky = true
        }
    }
end)
