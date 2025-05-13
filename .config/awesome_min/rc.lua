pcall(require, "luarocks.loader")

local awful = require("awful")
local gfs = require("gears").filesystem
local beautiful = require("beautiful")

beautiful.xresources.set_dpi(96, 1)
local w = gfs.get_random_file_from_dir (os.getenv("HOME") .. "/Pictures/wallpapers/", {'jpeg','jpg','svg','png'}, true);

--- very dangerous
os.execute(os.getenv("HOME").."/.local/bin/pywal.sh " .. w)
collectgarbage()

local theme = require("themes.default.theme")
theme.wallpaper = w
beautiful.init(theme)
require("my-rc")
--beautiful.init(gears.filesystem.get_configuration_dir() .. "themes/default/theme.lua")

