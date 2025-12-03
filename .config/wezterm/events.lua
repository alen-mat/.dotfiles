local wezterm = require('wezterm')

wezterm.on("open_in_vim", function(window, pane)
  local file = io.open("/tmp/wezterm_buf", "w")
  if file then
    file:write(pane:get_lines_as_text(3000))
    file:close()
    window:perform_action(
      wezterm.action({
        SpawnCommandInNewTab = { args = { "nvim", "/tmp/wezterm_buf", "-c", "call cursor(3000,0)" } },
      }),
      pane
    )
  end
end)


wezterm.on("open-uri", function(window, pane, uri)
  wezterm.log_info(window)
  wezterm.log_info(pane)
  wezterm.log_info(uri)
end)

local function tab_title(tab_info)
  local title = tab_info.tab_title
  if title and #title > 0 then
    return title
  end
  return tab_info.active_pane.title
end

local function left_status_padding(window, contents)
  local mid_width = 0;
  local tabs = window:mux_window():tabs();
  for idx, tab in ipairs(tabs) do
    local title = tab:get_title();
    mid_width = mid_width + math.floor(math.log(idx, 10)) + 1
    mid_width = mid_width + 2 + #title + 1
  end
  local tab_width = window:active_tab():get_size().cols;
  local max_left = tab_width / 2 - mid_width / 2;
  for _, tbl in ipairs(contents) do
    if tbl.Text then
      max_left = max_left - #tbl.Text
    end
  end
  return max_left
end

local function is_exe_name(pane, exe_name)
  local info = pane:get_foreground_process_info()
  return info and info.executable:gsub('(.*[/\\])(.*)', '%2') == exe_name
end

wezterm.on('user-var-changed', function(window, pane, name, value)
  if name == 'nvimStatusLine' and is_exe_name(pane, 'nvim') then
    wezterm.emit('update_status', window, pane)
  end
end)

wezterm.on('update-status', function(window, pane)
  local left_status_tbl = {}
  local right_status_tbl = {}
  local t = 'Your custom left status here'
  local date = wezterm.strftime '%Y-%m-%d %H:%M:%S'
  if is_exe_name(pane, 'nvim') and pane:get_user_vars().nvimStatusLine and pane:get_user_vars().nvimStatusLine ~= 'null' then
    t = pane:get_user_vars().nvimStatusLine
    left_status_tbl = {
      { Text = t },
    }
  else
    date = wezterm.strftime '%Y-%m-%d %H:%M:%S'
    left_status_tbl = {
      { Text = t },
    }
    right_status_tbl = {
      { Attribute = { Underline = 'Single' } },
      { Attribute = { Italic = true } },
      { Foreground = { AnsiColor = 'Fuchsia' } },
      'ResetAttributes',
      { Attribute = { Underline = 'Single' } },
      { Text = "::" .. window:active_workspace() },
      'ResetAttributes',
      { Text = date },
    }
  end
  local max_left = left_status_padding(window, left_status_tbl)
  left_status_tbl[#left_status_tbl + 1] = { Text = wezterm.pad_left(' ', max_left) }

  window:set_left_status(wezterm.format(left_status_tbl))
  window:set_right_status(wezterm.format(right_status_tbl))
end)
wezterm.on(
  'format-tab-title',
  function(tab, tabs, panes, config, hover, max_width)
    local edge_background = '#0b0022'
    local background = '#1b1032'
    local foreground = '#808080'

    if tab.is_active then
      background = '#2b2042'
      foreground = '#c0c0c0'
    elseif hover then
      background = '#3b3052'
      foreground = '#909090'
    end

    local edge_foreground = background

    local title           = tab_title(tab)
    title                 = wezterm.truncate_right(title, max_width - 2)

    local elements        = {
      { Background = { Color = edge_background } },
      { Foreground = { Color = edge_foreground } },
      { Text = wezterm.nerdfonts.pl_right_hard_divider },
      { Background = { Color = background } },
      { Foreground = { Color = foreground } },
      { Text = title },
    }

    local progress        = tab.active_pane and tab.active_pane.progress or nil
    if progress ~= 'None' then
      local color = 'green'
      local status
      if progress.Percentage ~= nil then
        -- status = string.format("%d%%", progress.Percentage)
        status = wezterm.nerdfonts["md_circle_slice_" .. math.floor(progress.Percentage / 12)]
      elseif progress.Error ~= nil then
        -- status = string.format("%d%%", progress.Error)
        status = wezterm.nerdfonts["md_circle_slice_" .. math.floor(progress.Error / 12)]
        color = 'red'
      elseif progress == 'Indeterminate' then
        status = '{~}'
      else
        status = wezterm.serde.json_encode(progress)
      end

      elements[#elements+1]= { Foreground = { Color = color } }
      elements[#elements+1]= { Text = " " .. status }
      elements[#elements+1]= { Foreground = 'Default' }
    end
    elements[#elements+1]={ Background = { Color = edge_background } }
    elements[#elements+1]={ Foreground = { Color = edge_foreground } }
    elements[#elements+1]={ Text = wezterm.nerdfonts.pl_left_hard_divider }
    return elements
  end
)


-- vim: ts=2 sts=2 sw=2 et
