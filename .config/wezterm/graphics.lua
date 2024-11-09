local wezterm = require 'wezterm'
local gpus = wezterm.gui.enumerate_gpus()

local graphics = {}
graphics.webgpu_preferred_adapter = gpus[1]
graphics.front_end = 'WebGpu'
graphics.webgpu_power_preference = "LowPower"
return graphics
