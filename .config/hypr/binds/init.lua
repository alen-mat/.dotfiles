local utils = require('utils')
local mainMod = "SUPER"

hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd('ghostty'))
hl.bind(mainMod .. " + SHIFT + Return", hl.dsp.exec_cmd('foot'))
hl.bind(mainMod .. " + BackSpace", hl.dsp.window.close())

hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + ALT + h", hl.dsp.window.move({ direction = "left", group_aware = true }))
hl.bind(mainMod .. " + ALT + l", hl.dsp.window.move({ direction = "right", group_aware = true }))
hl.bind(mainMod .. " + ALT + k", hl.dsp.window.move({ direction = "up", group_aware = true }))
hl.bind(mainMod .. " + ALT + j", hl.dsp.window.move({ direction = "down", group_aware = true }))

hl.bind(mainMod .. " + SHIFT + h", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + l", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + k", hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + j", hl.dsp.window.resize({ x = -10, y = 10, relative = true }), { repeating = true })
for i = 1, 10 do
  local key = i % 10 -- 10 maps to key 0
  hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
  hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end
local function switch_layout(direction)
  local layout_map = { master = 1, scrolling = 2, dwindle = 3, monocle = 4 }
  local layout_list = { "master", "scrolling", "dwindle", "monocle" }
  local ws = hl.get_active_workspace()
  local i = layout_map[ws.tiled_layout]
  local next_layout
  if direction == 'up' then
    next_layout = layout_list[(i % #layout_list) + 1]
  elseif direction == 'down' then
    next_layout = layout_list[(i % #layout_list) + 1]
  end
  if next_layout then
    hl.workspace_rule({ workspace = ws.name, layout = next_layout })
  end
end
hl.bind(mainMod .. " + Space", function()
  switch_layout('up')
end)
hl.bind(mainMod .. " + SHIFT + Space", function()
  switch_layout('down')
end)

-- Helper to safely compare float numbers with small tolerance
local function is_near(val, target, eps)
  eps = eps or 0.001
  return type(val) == "number" and math.abs(val - target) < eps
end

hl.bind(mainMod .. " + b", function()
  local a = hl.get_config("layout.single_window_aspect_ratio")
  local txt = "Single window mode : "

  -- Direct array index check with float tolerance
  local is_one_by_one = type(a) == "table"
      and is_near(a[1], 1.0)
      and is_near(a[2], 1.0)

  if is_one_by_one then
    hl.config({
      layout = {
        single_window_aspect_ratio = { 0.0, 0.0 },
      },
    })
    txt = txt .. "disabled"
  else
    hl.config({
      layout = {
        single_window_aspect_ratio = { 1.0, 1.0 },
      },
    })
    txt = txt .. "enabled"
  end
  hl.notification.create({
    text = txt,
    timeout = 4000,
    icon = "ok"
  })
end)
hl.bind(mainMod .. ' + q', hl.dsp.focus({ monitor = 'mon:-1' }))
hl.bind(mainMod .. ' + e', hl.dsp.focus({ monitor = 'mon:+1' }))
hl.bind(mainMod .. ' + CTRL + h', hl.dsp.focus({ monitor = 'left' }))
hl.bind(mainMod .. ' + CTRL + l', hl.dsp.focus({ monitor = 'right' }))
hl.bind(mainMod .. ' + CTRL + k', hl.dsp.focus({ monitor = 'up' }))
hl.bind(mainMod .. ' + CTRL + j', hl.dsp.focus({ monitor = 'down' }))
-- Example special workspace (scratchpad)
-- hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
-- hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))
hl.bind("SUPER + G", function()
  hl.dispatch(hl.dsp.group.toggle())
end)
-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("ALT + R", hl.dsp.submap("resize"))
hl.define_submap("resize", function()
  hl.bind("right", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })
  hl.bind("left", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
  hl.bind("up", hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })
  hl.bind("down", hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })
  hl.bind("escape", hl.dsp.submap("reset"))
end)

-- o.bind("SUPER + CTRL + F", "Tiled full screen", hl.dsp.window.fullscreen_state({ internal = 0, client = 2 }))
-- o.bind("SUPER + ALT + F", "Full width", hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(mainMod .. " + f ", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind(mainMod .. " + SHIFT + f ", hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(mainMod .. " + CTRL + f ", function()
  hl.notification.create({
    text = "placeholder fullscreen",
    timeout = 4000,
    icon = "ok"
  })
end)


hl.bind(mainMod .. " + ALT + f", function()
  hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
end)

hl.bind(mainMod .. '+ Y', hl.dsp.submap("Clean/Forward all"))
hl.define_submap("Clean/Forward all", function()
  hl.bind(mainMod .. " + escape", hl.dsp.submap("reset"))
end)


hl.bind(mainMod .. ' + SHIFT + P', hl.dsp.submap("Launcher"))
hl.define_submap("Launcher", function()
  hl.bind("c", function()
    utils.run_or_raise(
      "cliamp.cliamp",
      [[sh -c 'PATH=$PATH:]] ..
      os.getenv("HOME") ..
      [[/.local/bin;ghostty --confirm-close-surface=false --keybind="clear" --gtk-single-instance=false --class=cliamp.cliamp -e "cliamp-linux-amd64"']],
      { float = true, workspace = 6, size = { 940, 570 } })

    hl.dispatch(hl.dsp.submap("reset"))
  end)

  hl.bind("b", function()
    utils.run_or_raise(
      "bookokrat.bookokrat",
      [[sh -c 'PATH=$PATH:]] ..
      os.getenv("HOME") ..
      [[/.local/bin;ghostty --confirm-close-surface=false --keybind="clear" --gtk-single-instance=false --class=bookokrat.bookokrat -e "bookokrat"']],
      { float = true, workspace = 7, size = { 1210, 690 } })

    hl.dispatch(hl.dsp.submap("reset"))
  end)

  hl.bind("w", function()
    hl.dispatch(hl.dsp.exec_cmd(
      [[sh -c "/opt/Citrix/ICAClient/wfica \"$(find ]] ..
      os.getenv("HOME") ..
      [[/Downloads -type f -name '*.ica' -printf '%T@ %p\n' | sort -n | tail -n 1 | cut -d' ' -f2-)\""]]
    ))
    hl.dispatch(hl.dsp.submap("reset"))
  end)
  hl.bind(mainMod .. " + escape", hl.dsp.submap("reset"))
  hl.bind("escape", hl.dsp.submap("reset"))
end)

---- screenshot ----
local function screenShotHelper(mode)
  local cmd = ''
  if mode == "region" then
    cmd = 'grim -g "$(slurp)" - | wl-copy'
  elseif mode == "window" then
    local jq_filter = '\'.[] | select(.workspace.id != -1) | "\\(.at[0]),\\(.at[1]) \\(.size[0])x\\(.size[1])"\''
    cmd = string.format('grim -g "$(hyprctl clients -j | jq -r %s | slurp)" - | wl-copy', jq_filter)
  elseif mode == "output" then
    cmd = 'grim -g "$(slurp -o)" - | wl-copy'
  elseif mode == "screen" then
    cmd = 'grim - | wl-copy'
  end
  hl.dispatch(hl.dsp.exec_cmd(cmd))
end
hl.bind("Print", function()
  screenShotHelper('screen')
end, { locked = true })
hl.bind("CTRL + Print", function()
  screenShotHelper('screen')
end, { locked = true })
--hl.bind("Print", hl.dsp.exec_cmd(nshell_ipc_call .. " media next"), { locked = true })
--------------------

require('binds.noctalia')

-- vim: ts=2 sts=2 sw=2 et
