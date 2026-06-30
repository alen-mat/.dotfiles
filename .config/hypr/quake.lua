-- =============================================================================
-- Hyprland Lua Configuration (0.55+)
-- Feature: Bottom-Anchored Quake-Style Dropdown Terminal
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. Window Rules
-- -----------------------------------------------------------------------------

-- Configures the foot terminal to slide up from the bottom and float cleanly
hl.window_rule({
    match = { class = "foot-quake" },
    float = true,
    move = { "10%", "60%" },          -- 10% from left, 60% from top (lines up at bottom)
    size = { "80%", "40%" },          -- App takes up 80% width, 40% height of screen
    animation = "slide up",           -- Smoothly slides up from the bottom edge
    workspace = "special:quake silent" -- Spawns hidden on an isolated special workspace
})


-- -----------------------------------------------------------------------------
-- 2. Custom Toggle Function
-- -----------------------------------------------------------------------------

local function toggle_quake_terminal()
    local windows = hl.get_windows()
    local quake_win = nil

    -- Scan for the running foot-quake instance
    for _, win in ipairs(windows) do
        if win.class == "foot-quake" then
            quake_win = win
            break
        end
    end

    local active_win = hl.get_active_window()
    
    if quake_win == nil then
        -- Step A: Not running yet. Spawn a brand new instance
        hl.exec_cmd("foot --class=foot-quake")
    elseif active_win ~= nil and active_win.address == quake_win.address then
        -- Step B: Currently focused. Send it back down to the hidden workspace
        hl.dispatch(hl.dsp.window.move({ 
            window = "address:" .. quake_win.address, 
            workspace = "special:quake" 
        }))
    else
        -- Step C: Hidden or out of focus. Pull it up to your active workspace and focus it
        local current_ws = hl.get_active_workspace().name
        
        hl.dispatch(hl.dsp.window.move({ 
            window = "address:" .. quake_win.address, 
            workspace = current_ws 
        }))
        hl.dispatch(hl.dsp.focus({ window = "address:" .. quake_win.address }))
    end
end


-- -----------------------------------------------------------------------------
-- 3. Keybinding
-- -----------------------------------------------------------------------------

local mainMod = "SUPER"

-- Bind the toggle behavior to SUPER + ` (Grave / Tilde key)
hl.bind(mainMod .. " + grave", toggle_quake_terminal, { description = "Toggle Bottom Quake Terminal" })
