local awful = require('awful')
local beautiful = require('beautiful')
local gears = require('gears')
local apps = require('configuration.apps')
local dpi = require('beautiful').xresources.apply_dpi

local tags = {{
    text = '一',
    screen = 1
}, {
    text = '二',
    screen = 1
}, {
    text = '三',
    screen = 1
}, {
    text = '四',
    screen = 1
}, {
    text = '五',
    screen = 1
}, {
    text = '六',
    screen = 1
},{
    text = '七',
    screen = 1
},{
    text = '八',
    screen = 1
},{
    text = '九',
    screen = 1
}}

awful.layout.layouts = {
	awful.layout.suit.tile,
	awful.layout.suit.magnifier, 
	awful.layout.suit.fair,
	awful.layout.suit.max,
	awful.layout.suit.max.fullscreen,
	awful.layout.suit.floating
}

awful.screen.connect_for_each_screen(function(s)
    for i, tag in pairs(tags) do
        awful.tag.add(tag.text, {
            icon = tag.icon,
            icon_only = false,
            layout = awful.layout.suit.tile,
            gap = beautiful.gaps,
            screen = s,
            defaultApp = tag.defaultApp,
            selected = i == 1
        })
    end
end)
