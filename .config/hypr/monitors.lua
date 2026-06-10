hl.monitor {
  output   = "",
  mode     = "preferred",
  position = "auto",
  scale    = 1,
}

hl.monitor {
  output = 'eDP-1',
  mode = 'preferred',
  position = 'auto',
  scale = 1
}
local monitors = hl.get_monitors()

for _, monitor in ipairs(monitors) do
  for i = 1, 5 do
    hl.workspace_rule({ workspace = tostring(i), monitor = monitor.name, persistent = true })
  end
end
-- vim: ts=2 sts=2 sw=2 et
