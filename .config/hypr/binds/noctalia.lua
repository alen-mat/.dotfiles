local nshell_ipc_call = 'noctalia msg'

hl.bind("SUPER + p", hl.dsp.exec_cmd(nshell_ipc_call .. " panel-toggle launcher "), { locked = true, repeating = false })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(nshell_ipc_call .. ' volume-up '), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(nshell_ipc_call .. ' volume-down'), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(nshell_ipc_call .. ' volume-mute'), { locked = true })

hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(nshell_ipc_call .. ' mic-mute'),
  { locked = true })

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(nshell_ipc_call .. " brightness-up"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(nshell_ipc_call .. " brightness-down"),
  { locked = true, repeating = true })

hl.bind("XF86KbdBrightnessUp", hl.dsp.exec_cmd(nshell_ipc_call .. " brightness-up"), { locked = true, repeating = true })
hl.bind("XF86KbdBrightnessDown", hl.dsp.exec_cmd(nshell_ipc_call .. " brightness-up"), { locked = true, repeating = true })
hl.bind("XF86KbdLightOnOff", hl.dsp.exec_cmd(nshell_ipc_call .. " brightness-up"), { locked = true})

hl.bind("XF86TouchpadToggle", hl.dsp.exec_cmd(nshell_ipc_call .. " brightness-up"), { locked = true})
hl.bind("XF86TouchpadOn", hl.dsp.exec_cmd(nshell_ipc_call .. " brightness-up"), { locked = true})
hl.bind("XF86TouchpadOff", hl.dsp.exec_cmd(nshell_ipc_call .. " brightness-up"), { locked = true})

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd(nshell_ipc_call .. " media next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd(nshell_ipc_call .. " media playPause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(nshell_ipc_call .. " media playPause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd(nshell_ipc_call .. " media previous"), { locked = true })

-- vim: ts=2 sts=2 sw=2 et
