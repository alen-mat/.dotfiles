local awful = require('awful')
require('awful.autofocus')
local modkey = require('configuration.keys.mod').modKey
local altkey = require('configuration.keys.mod').altKey

local clientKeys = awful.util.table.join(awful.key({modkey}, 'f', function(c)
    c.fullscreen = not c.fullscreen
    c:raise()
end, {
    description = 'toggle fullscreen',
    group = 'client'
}), awful.key({modkey, 'Shift'}, 'q', function(c)
    c:kill()
end, {
    description = 'close',
    group = 'client'
}) , awful.key({modkey, 'Shift'}, 'f', function(c)
    c.sticky = not c.sticky
    c.ontop = not c.ontop
    c:raise()
end, {
    description = 'convert to sticky window',
    group = 'client'
}), awful.key({modkey}, 'BackSpace', function(c)
    c:kill()
end, {
    description = 'close',
    group = 'client'
}),awful.key({ modkey}, "Return", 
    function (c) 
        c:swap(awful.client.getmaster())
end,{
    description = "move to master", 
		group = "client"
}),awful.key({modkey,altkey},"f",
    function(c)
				awful.client.floating.toggle(c)
    end,{
    description = "Toggle Float",
		group = "client"
})
)


return clientKeys
