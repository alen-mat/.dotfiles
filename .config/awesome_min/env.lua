local awful = require("awful")

_G.env = {
    keys =  {
        mod = "Mod4",
        alt = "Mod1"
    },
    terminal = "wezterm",
    theme_name = "",
    user_home = os.getenv("HOME"),
    config_dir = awful.util.getdir("config")
}
_G.env.wallpaper_folder = _G.env.user_home .. "/Pictures/arch-linux"
_G.env.wallpaper = _G.env.user_home .. "/Pictures/arch-linux/solar.jpg"

