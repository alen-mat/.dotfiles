hl.env(  "XDG_CURRENT_DESKTOP","Hyprland")
hl.env(  "XDG_SESSION_TYPE","wayland")
hl.env(  "XDG_SESSION_DESKTOP","Hyprland")


hl.env(  "ELECTRON_OZONE_PLATFORM_HINT","auto")

--- QT_QPA_PLATFORM,wayland;xcb;offscreen
hl.env(  "QT_QPA_PLATFORM", "wayland")
--hl.env(  "QT_QPA_PLATFORMTHEME","qt5ct")
hl.env(  "QT_QPA_PLATFORMTHEME", "kde")
hl.env(  "QT_AUTO_SCREEN_SCALE_FACTOR","1")
hl.env(  "QT_WAYLAND_DISABLE_WINDOWDECORATION","1")

hl.env("HYPRCURSOR_THEME", "nier-cursors-bin")
hl.env("XCURSOR_THEME", "nier-cursors-bin")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")


