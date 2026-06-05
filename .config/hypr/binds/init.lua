local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd('ghostty'))
local closeWindowBind = hl.bind(mainMod .. " + BackSpace", hl.dsp.window.close())
--closeWindowBind:set_enabled(false)
--hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
--hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
--hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))    -- dwindle only

hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + ALT + h", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + ALT + l", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + ALT + k", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + ALT + j", hl.dsp.window.move({ direction = "down" }))

hl.bind(mainMod .. " + SHIFT + h", hl.dsp.window.resize({ x = -10, y = 0, relative = true }))
hl.bind(mainMod .. " + SHIFT + l", hl.dsp.window.resize({ x = 10, y = 0, relative = true }))
hl.bind(mainMod .. " + SHIFT + k", hl.dsp.window.resize({ x = 0, y = -10, relative = true }))
hl.bind(mainMod .. " + SHIFT + j", hl.dsp.window.resize({ x = -10, y = 10, relative = true }))
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

hl.bind(mainMod..' + q', hl.dsp.focus({ monitor = 'mon:-1' }))
hl.bind(mainMod..' + e', hl.dsp.focus({ monitor = 'mon:+1' }))
hl.bind(mainMod..' + CTRL + h', hl.dsp.focus({ monitor = 'left' }))
hl.bind(mainMod..' + CTRL + l', hl.dsp.focus({ monitor = 'right' }))
hl.bind(mainMod..' + CTRL + k', hl.dsp.focus({ monitor = 'up' }))
hl.bind(mainMod..' + CTRL + j', hl.dsp.focus({ monitor = 'down' }))
-- Example special workspace (scratchpad)
-- hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
-- hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

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

hl.bind(mainMod .. " + f", function()
  local window = hl.get_active_window()
  -- hl.dsp.window.fullscreen_state({(window.fullscreen+1 % 4)})
  hl.notification.create({
    text ='place holder for fullscreen',
    timeout = 4000,
    icon = "ok"
  })
end)

hl.bind(mainMod .. " + SHIFT  + f", function()
  hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
end)

hl.bind(mainMod .. '+ Y', hl.dsp.submap("Clean/Forward all"))
hl.define_submap("Clean/Forward all", function()
  hl.bind(mainMod.." + escape", hl.dsp.submap("reset"))
end)
require('binds.noctalia')

-- vim: ts=2 sts=2 sw=2 et
