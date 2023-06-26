local t = require('bars.topbar')
local b = require('bars.bottombar')

local function initbar(s)
    t(s)
    b(s)
end

return initbar
