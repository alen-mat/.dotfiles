
local M = {}
M.deep_compare = function(tbl1, tbl2, visited)
    -- Check raw memory reference / identical primitives
    if rawequal(tbl1, tbl2) then return true end

    -- Type check
    if type(tbl1) ~= "table" or type(tbl2) ~= "table" then return false end

    -- Guard against circular references
    visited = visited or {}
    if visited[tbl1] and visited[tbl1] == tbl2 then return true end
    visited[tbl1] = tbl2

    -- Check all key-value pairs in tbl1 match tbl2
    for key, value in pairs(tbl1) do
        if not M.deep_compare(value, tbl2[key], visited) then
            return false
        end
    end

    -- Check for keys in tbl2 that are missing in tbl1
    for key in pairs(tbl2) do
        if tbl1[key] == nil then
            return false
        end
    end

    return true
end


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
-- Example Usage:
