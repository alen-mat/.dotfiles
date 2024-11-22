local naughty = require('naughty')
local awful = require("awful")
local home = os.getenv("HOME")

local M = {}

local ss = '/usr/bin/maim -f png '

local function gen_file_name()
  local time = os.date("%Y-%m-%d-%H-%M-%S")
  return screenshot_dir .. "screenshot_" .. time .. ".png"
end

local function notify(file_name)
  local content = "Saved to " .. file_name
  if file_name == '/tmp/Screenshot.png' then
    content = 'Copied to clipboard'
  end
  if file_name:sub(1, 1) == '~' then
    file_name = string.gsub(file_name, "%~", home)
  end

  naughty.notify({
    -- screen = 1,
    -- timeout = 0,-- in seconds
    -- ignore_suspend = true,-- if true notif shows even if notifs are suspended via naughty.suspend
    -- fg = "#ff0",
    -- bg = "#ff0000",
    title = "Screeshot",
    text = content,
    icon = file_name,
    -- icon = gears.color.recolor_image(notif_icon, "#ff0"),
    -- icon_size = 24,-- in px
    border_color = "#ffff00",
    border_width = 2,
  })
end

local function _screenshot(args, clip)
  local file_name = ((clip and gen_file_name()) or "/tmp/Screenshot.png")
  local command = ss .. args.. file_name 
  if file_name == '/tmp/Screenshot.png' then
    command = command .. " && xclip -selection clipboard -t image/png -i /tmp/Screenshot.png"
  end

  naughty.notify({
    title = "Screeshot",
    text = command,
  })
  awful.spawn.easy_async_with_shell(command, function(stdout, stderr, reason, exit_code)
    if exit_code == 0 then
      notify(file_name)
    else
      naughty.notify({ title = "Error", text = stderr })
    end
  end)
end

M['full_screen'] = function(clip)
  _screenshot('', clip)
end

M['selection'] = function(clip)
  _screenshot("-s ", clip)
end

M['aw'] = function(clip)
  _screenshot("-i $(xdotool getactivewindow) ", clip)
end

return M
