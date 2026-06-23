-- Disable blur for xwayland context menus
hl.window_rule {
  name = "windowrule-1",
  no_blur = true,
  match = { class = "^()$",
    title = "^()$" }
}


-- Floating
hl.window_rule {
  name = "windowrule-2",
  float = true,
  match = { class = "^(blueberry\\.py)$" },
}

hl.window_rule {
  name = "windowrule-3",
  float = true,
  match = { class = "^(steam)$", }
}

hl.window_rule {
  workspace = 9,
  name = "windowrule-localsend",
  float = true,
  match = { class = "^(localsend)$", title = "^(LocalSend)$" },
  size = { 408, 683 }
}

hl.window_rule {
  name = "windowrule-4",
  float = true,
  match = { class = "^(guifetch)$", }
}

hl.window_rule {
  name = "windowrule-5",
  float = true,
  size = { "(monitor_w*0.45)", "(monitor_h*0.45)" },
  center = true,
  match = { class = "^(pavucontrol)$", }
}

hl.window_rule {
  name = "windowrule-6",
  float = true,
  size = { "(monitor_w*0.45)", "(monitor_h*0.45)" },
  center = true,
  match = { class = "^(org.pulseaudio.pavucontrol)$", }
}

hl.window_rule {
  name = "windowrule-7",
  float = true,
  size = { "(monitor_w*0.45)", "(monitor_h*0.45)" },
  center = true,
  match = { class = "^(nm-connection-editor)$", }
}

hl.window_rule {
  name = "windowrule-8",
  float = true,
  match = { class = ".*plasmawindowed.*", }
}

hl.window_rule {
  name = "windowrule-9",
  float = true,
  match = { class = "kcm_.*", }
}

hl.window_rule {
  name = "windowrule-10",
  float = true,
  match = { class = ".*bluedevilwizard", }
}

hl.window_rule {
  name = "windowrule-11",
  float = true,
  match = { title = ".*Welcome", }
}

hl.window_rule {
  name = "windowrule-13",
  float = true,
  match = { class = "org.freedesktop.impl.portal.desktop.kde", }
}


-- No appearance
-- kde-material-you-colors spawns a window when changing dark/light theme. This is to make sure it doesn't interfere at all.
hl.window_rule {
  name = "windowrule-14",
  float = true,
  no_initial_focus = true,
  move = "(999999) (999999)",
  match = { class = "^(plasma-changeicons)$", }
}


-- Tiling
hl.window_rule {
  name = "windowrule-15",
  tile = true,
  match = { class = "^dev\\.warp\\.Warp$", }
}


-- Picture-in-Picture
hl.window_rule {
  name = "windowrule-16",
  float = true,
  keep_aspect_ratio = true,
  move = "((monitor_w*0.73)) ((monitor_h*0.72))",
  size = { "(monitor_w*0.25)", "(monitor_h*0.25)" },
  pin = true,
  match = { title = "^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$", }
}


-- Dialog windows – float+center these windows.
hl.window_rule {
  name = "windowrule-17",
  center = true,
  float = true,
  match = { title = "^(Open File)(.*)$", }
}

hl.window_rule {
  name = "windowrule-18",
  center = true,
  float = true,
  match = { title = "^(Select a File)(.*)$", }
}

hl.window_rule {
  name = "windowrule-19",
  center = true,
  float = true,
  match = { title = "^(Choose wallpaper)(.*)$", }
}

hl.window_rule {
  name = "windowrule-20",
  center = true,
  float = true,
  match = { title = "^(Open Folder)(.*)$", }
}

hl.window_rule {
  name = "windowrule-21",
  center = true,
  float = true,
  match = { title = "^(Save As)(.*)$", }
}

hl.window_rule {
  name = "windowrule-22",
  center = true,
  float = true,
  match = { title = "^(Library)(.*)$", }
}

hl.window_rule {
  name = "windowrule-23",
  center = true,
  float = true,
  match = { title = "^(File Upload)(.*)$", }
}


--- Tearing ---
hl.window_rule {
  name = "windowrule-24",
  immediate = true,
  match = { title = ".*\\.exe", }
}

hl.window_rule {
  name = "windowrule-25",
  immediate = true,
  match = { title = ".*minecraft.*", }
}

hl.window_rule {
  name = "windowrule-26",
  immediate = true,
  match = { class = "^(steam_app)", }
}


-- No shadow for tiled windows (matches windows that are not floating).
hl.window_rule {
  name = "windowrule-27",
  no_shadow = true,
  match = { float = "0", }
}
hl.workspace_rule({ workspace = "2", layout = "scrolling" })
hl.workspace_rule({ workspace = "s[true]", no_rounding = true, decorate = false })

-- xwayland video bridge
hl.window_rule { match = { class = "^(xwaylandvideobridge)$" }, opacity = "0.0" }
hl.window_rule { match = { class = "^(xwaylandvideobridge)$", }, no_anim = true }
hl.window_rule { match = { class = '^(xwaylandvideobridge)$', }, no_initial_focus = true }
hl.window_rule { match = { class = '^(xwaylandvideobridge)$', }, max_size = { 1, 1 } }
hl.window_rule { match = { class = '^(xwaylandvideobridge)$', }, no_blur = true }
hl.window_rule { match = { class = '^(xwaylandvideobridge)$', }, no_focus = true }

--# ######## Layer rules ########
hl.layer_rule { xray = true, match = { class = '.*' } }
hl.layer_rule { no_anim = true, match = { class = 'walker' } }
hl.layer_rule { no_anim = true, match = { class = 'selection' } }
hl.layer_rule { no_anim = true, match = { class = 'overview' } }
hl.layer_rule { no_anim = true, match = { class = 'anyrun' } }
hl.layer_rule { no_anim = true, match = { class = 'indicator.*' } }
hl.layer_rule { no_anim = true, match = { class = 'osk' } }
hl.layer_rule { no_anim = true, match = { class = 'hyprpicker' } }


--Spotify
hl.window_rule {
  workspace = 6,
  no_initial_focus = true,
  float = true,
  size = { 1038, 622 },
  match = { class = '[Ss]potify', },
}

--youtube-music
hl.window_rule { float = true, workspace = 6, no_initial_focus = true, size = { 1038, 622 }, match = { class = 'com.github.th_ch.youtube_music', }, }

-- Citrix
hl.window_rule { float = true, no_initial_focus = true, workspace = 4, match = { class = "Wfica" } }

-- Zoom
hl.window_rule { float = true, workspace = 9, match = { class = "[Zz]oom" } }

-- anki
hl.window_rule { float = true, center = true, match = { class = '^(anki)$', title = "^(Add|Browse|Preferences|Options|Export|Import|Statistics)$" } }

-- Android Studio
hl.window_rule {
  name = "windowrule-1",
  no_initial_focus = true,
  match = { class = "(jetbrains-studio)",
    title = "^win(.*)", }
}


local suppressMaximizeRule = hl.window_rule({
  -- Ignore maximize requests from all apps. You'll probably like this.
  name           = "suppress-maximize-events",
  match          = { class = ".*" },

  suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
  -- Fix some dragging issues with XWayland
  name     = "fix-xwayland-drags",
  match    = {
    class      = "^$",
    title      = "^$",
    xwayland   = true,
    float      = true,
    fullscreen = false,
    pin        = false,
  },

  no_focus = true,
})

hl.window_rule({
  name  = "move-hyprland-run",
  match = { class = "hyprland-run" },

  move  = "20 monitor_h-120",
  float = true,
})
-- vim: ts=2 sts=2 sw=2 et
