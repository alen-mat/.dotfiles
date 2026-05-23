local nshell_ipc_call = 'qs -c noctalia-shell ipc call'

hl.bind("SUPER + p", hl.dsp.exec_cmd(nshell_ipc_call.." launcher toggle"), { locked = true, repeating = false})
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(nshell_ipc_call .. ' volume increase'), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(nshell_ipc_call .. ' volume decrease'),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd(nshell_ipc_call .. ' volume muteOutput'),     { locked = true, repeating = true })

hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })

hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd(nshell_ipc_call.." brightness increase"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd(nshell_ipc_call.." brightness decrease"),                  { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd(nshell_ipc_call.." media next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd(nshell_ipc_call.." media playPause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd(nshell_ipc_call.." media playPause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd(nshell_ipc_call.." media previous"),   { locked = true })

-- vim: ts=2 sts=2 sw=2 et
