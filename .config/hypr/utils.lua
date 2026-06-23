local M = {}
-- Simulate XMonad's run_or_raise function natively in Lua
M.run_or_raise = function (class_match, command,exec_rules)
-- Accepts an optional rules table to pass down to exec_cmd
    local windows = hl.get_windows()
    local found = false

    for _, window in ipairs(windows) do
        if window.class and string.lower(window.class) == string.lower(class_match) then
            -- If found, jump focus to the running instance
            hl.dispatch(hl.dsp.focus({ window = "address:" .. window.address }))
            found = true
            break
        end
    end

    -- If not found, spawn it with the optional execution rules
    if not found then
        -- Default to an empty table if no rules were passed
        hl.dispatch(hl.dsp.exec_cmd(command, exec_rules or {}))
    end
end
return M
