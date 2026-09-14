hl.workspace_rule({ workspace = "2", layout = "scrolling" })
hl.workspace_rule({ workspace = "s[true]", no_rounding = true, decorate = false })

-- smart gaps
hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]", gaps_out = 0, gaps_in = 0 })
hl.window_rule({ match = { float = false, workspace = "w[tv1]" }, border_size = 0,rounding = 0 })
hl.window_rule({ match = { float = false, workspace = "f[1]" }, border_size = 0 ,rounding = 0})
