-- 1. Window Rules
hl.window_rule({
    match = { class = "kitty-quake" },
    float = true,
    move = { "10%", "60%" },
    size = { "80%", "40%" },
    workspace = "special:quake silent", 
    pin = false
})

-- 2. Toggle Logic
local function toggle_quake_terminal()
    local windows = hl.get_windows()
    local is_running = false

    -- Check if it's already running
    for _, win in ipairs(windows) do
        if win.class == "kitty-quake" then
            is_running = true
            break
        end
    end

    -- If not running, spawn it directly to the special workspace
    if not is_running then
        hl.exec_cmd("kitty --class=kitty-quake")
    end
    
    -- Always use the native special workspace toggle.
    -- This brings the overlay down on whatever workspace you are currently on.
    hl.dispatch(hl.dsp.workspace.toggle_special("quake"))
end

-- 3. Keybinding
hl.bind("ALT + 1", toggle_quake_terminal, { description = "Toggle Bottom Quake Terminal" })
