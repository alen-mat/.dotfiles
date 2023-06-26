local awful = require('awful')
local apps = {
  'picom -f --experimental-backend --config ~/.config/picom/picom  -b',
  'xsetroot -cursor_name left_ptr ',
  'touchegg',
  'mpd',
  'lxqt-policykit-agent'
}

local function run_once(cmd)
  local findme = cmd
  local firstspace = cmd:find(' ')
  if firstspace then
    findme = cmd:sub(0, firstspace - 1)
  end
  awful.spawn.with_shell(string.format('pgrep -u $USER -x %s > /dev/null || (%s)', findme, cmd))
  --This broke compton ===>   awful.spawn.single_instance(string.format('pgrep -u $USER -x %s > /dev/null || (%s)', findme, cmd))
end

for _, app in ipairs(apps) do
  run_once(app)
end
