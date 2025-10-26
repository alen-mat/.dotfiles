local awful = require("awful")

local M = {
    keys =  {
        mod = "Mod4",
        alt = "Mod1"
    },
    terminal = "wezterm",
    theme_name = "",
    user_home = os.getenv("HOME"),
    config_dir = awful.util.getdir("config"),
    editor = 'nvim'
}
function M:init ()
    self.wallpaper_folder = self.user_home .. "/Pictures/arch-linux"
end

return M
