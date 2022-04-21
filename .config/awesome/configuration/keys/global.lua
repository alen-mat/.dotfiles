require('awful.autofocus')
local awful = require('awful')
local hotkeys_popup = require('awful.hotkeys_popup').widget
local modkey = require('configuration.keys.mod').modKey
local altkey = require('configuration.keys.mod').altKey
local apps = require('configuration.apps')

local globalKeys = awful.util.table.join(
	awful.key({modkey}, '/', hotkeys_popup.show_help, {
  	  description = 'show help',
    	group = 'Awesome'
	}),
 	awful.key({modkey}, 'F1', hotkeys_popup.show_help, {
    	description = 'show help',
    	group = 'Awesome'
	}),
	awful.key({modkey}, 'l', 
		function()
  		awful.spawn(apps.default.lock)
		end, {
			description = 'lock the screen',
			group = 'Awesome'
	}),
	awful.key({modkey, 'Control'}, 'q', _G.awesome.restart, {
			description = 'reload awesome',
			group = 'Awesome'
	}),
	awful.key({modkey, 'Shift'}, 'q', _G.awesome.quit, {
			description = 'quit awesome',
			group = 'Awesome'
	}),
-------------------------------
-----------Apps----------------
-------------------------------
	awful.key({modkey,'Shift'}, 'Return', 
		function()
    	awful.util.spawn_with_shell(apps.default.terminal)
		end, {
    	description = 'open a terminal',
    	group = 'Apps'
	}),
-------------------------------
-----------Rofi----------------
-------------------------------
	awful.key({modkey}, 'p',
		function()
			awful.util.spawn_with_shell(apps.default.rofi)
		end, {
    	description = 'Apps',
    	group = 'Rofi'
	}), 
	awful.key({modkey}, '[', 
		function()
  	  awful.util.spawn_with_shell('~/.local/bin/rofi_helper -bm')
		end, {
    	description = 'Bluetooth Manager',
    	group = 'Rofi'
	}),
	awful.key({modkey}, ']', 
		function()
  	  awful.util.spawn_with_shell('~/.local/bin/rofi_helper -nm')
		end, {
    	description = 'Network Manager',
    	group = 'Rofi'
	}),
	awful.key({modkey}, ';', 
		function()
  	  awful.util.spawn_with_shell(apps.default.power_command)
		end, {
    	description = 'Power Menu',
    	group = 'Rofi'
	}),
	awful.key({modkey}, 'v', 
		function()
  	  awful.util.spawn_with_shell('~/.local/bin/rofi_helper -gc')
		end, {
    	description = 'Clipboard',
    	group = 'Rofi'
	}),
	awful.key({modkey}, 'Tab', 
		function()
  	  awful.util.spawn_with_shell('~/.local/bin/rofi_helper -ss')
		end, {
    	description = 'Switcher',
    	group = 'Rofi'
	}),
	awful.key({modkey, altkey}, '.', 
		function()
  	  awful.util.spawn_with_shell('~/.local/bin/rofi_helper -ep')
		end, {
    	description = 'Switcher',
    	group = 'Rofi'
	}),
	awful.key({modkey, altkey}, 'b', 
		function()
  	  awful.util.spawn_with_shell('~/.local/bin/rofi_helper -bb')
		end, {
    	description = 'Switcher',
    	group = 'Rofi'
	}),
	awful.key({modkey, altkey}, '/', 
		function()
  	  awful.util.spawn_with_shell('~/.local/bin/rofi_helper -bw')
		end, {
    	description = 'Switcher',
    	group = 'Rofi'
	}),
	awful.key({modkey}, ';', 
		function()
  	  awful.util.spawn_with_shell(apps.default.power_command)
		end, {
 	  	description = 'Power Menu',
  	 	group = 'Rofi'
	}),
-------------------------------
--------brightness-------------
-------------------------------
	awful.key({}, 'XF86MonBrightnessUp',
		function()
  	  awful.spawn('xbacklight -inc 10')
		end, {
    	description = '+10%',
    	group = 'Brightness'
	}), 
	awful.key({}, 'XF86MonBrightnessDown',
		function()
  	  awful.spawn('xbacklight -dec 10')
		end, {
    	description = '-10%',
    	group = 'Brightness'
	}),
-------------------------------
-----------Audio---------------
-------------------------------
	awful.key({altkey}, 'k',
		function()
    	awful.spawn.easy_async('amixer -D pulse sset Master 5%+', 
				function()
      		_G.update_volume()
    		end
			)
		end, {
    	description = 'volume up',
    	group = 'Audio'
	}), 
	awful.key({}, 'XF86AudioRaiseVolume', 
		function()
    	awful.spawn.easy_async('amixer -D pulse sset Master 5%+',
				function()
        	_G.update_volume()
    		end
			)
		end, {
    	description = 'volume up',
    	group = 'Audio'
	}), 
	awful.key({}, 'XF86AudioLowerVolume',
		function()
    	awful.spawn.easy_async('amixer -D pulse sset Master 5%-',
				function()
        	_G.update_volume()
    		end
			)
		end, {
    	description = 'volume down',
    	group = 'Audio'
	}), 
	awful.key({altkey}, 'j', 
		function()
    	awful.spawn.easy_async('amixer -D pulse sset Master 5%-',
				function()
        	_G.update_volume()
    		end
			)
		end, {
    	description = 'volume down',
    	group = 'Audio'
	}), 
	awful.key({altkey}, 'm', 
		function()
    	awful.spawn('amixer -D pulse set Master 1+ toggle')
	   	_G.update_volume()
		end, {
    	description = 'toggle mute',
    	group = 'Audio'
	}), 
	awful.key({}, 'XF86AudioMute', 
		function()
    	awful.spawn('amixer -D pulse set Master 1+ toggle')
    	_G.update_volume()
		end, {
   		description = 'toggle mute',
    	group = 'Audio'
	}), 
	awful.key({}, 'XF86AudioMicMute',
		function()
    	awful.spawn('amixer set Capture toggle')
    	_G.update_volume()
		end, {
    	description = 'toggle mic mute',
	    group = 'Audio'
	}),
	awful.key({}, 'XF86AudioPlay',
		function()
    	awful.spawn('playerctl play-pause && echo "play-pause" | ~/.local/bin/usr_notification_helper media')
		end, {
    	description = 'Play / Pause',
	    group = 'Audio'
	}),
	awful.key({}, 'XF86AudioStop',
		function()
    	awful.spawn('playerctl stop && echo "Stopped" | ~/.local/bin/usr_notification_helper media')
		end, {
    	description = 'Stop',
	    group = 'Audio'
	}),
	awful.key({}, 'XF86AudioPrev',
		function()
    	awful.spawn('playerctl previous && echo "Now Playing" | ~/.local/bin/usr_notification_helper media')
		end, {
    	description = 'Previous',
	    group = 'Audio'
	}),
	awful.key({}, 'XF86AudioNext',
		function()
    	awful.spawn('playerctl next && echo "Now Playing" | ~/.local/bin/usr_notification_helper media')
		end, {
    	description = 'Next',
	    group = 'Audio'
	}),
-------------------------------
-----------Fn keys-------------
-------------------------------
	awful.key({}, 'XF86HomePage',
		function()
    	awful.spawn('brave')
		end, {
    	description = 'Homepage',
	    group = 'Fn-Keys'
	}),
	awful.key({}, 'XF86Search',
		function()
    	awful.spawn('dmsearch')
		end, {
    	description = 'Search',
	    group = 'Fn-Keys'
	}),
	awful.key({}, 'XF86Mail',
		function()
    	awful.spawn('thunderbird')
		end, {
    	description = 'Mail',
	    group = 'Fn-Keys'
	}),
	awful.key({}, 'XF86Calculator',
		function()
    	awful.spawn('qalculate-gtk')
		end, {
    	description = 'Calculator',
	    group = 'Fn-Keys'
	}),
	awful.key({}, 'XF86Eject',
		function()
    	awful.spawn('toggleeject')
		end, {
    	description = 'Eject',
	    group = 'Fn-Keys'
	}),
-------------------------------
---------Scratch Pad-------------
-------------------------------
	awful.key({modkey,'Control'}, 't',
		function()
    	_G.toggle_splash()
		end, {
    	description = 'toggle splash terminal',
	    group = 'Scratch Pad'
	}),
-------------------------------
-------Workspace / Tag---------
-------------------------------
	awful.key({modkey}, ',',
		function()
    	awful.tag.viewprev()
	    _G._splash_to_current_tag()
		end, {
    	description = 'go to previous workspace',
    	group = 'Workspace / Tag'
	}), 
	awful.key({modkey}, '.', 
		function()
  	  awful.tag.viewnext()
    	_G._splash_to_current_tag()
		end, {
    	description = 'go to next workspace',
	    group = 'Workspace / Tag'
	}),
	awful.key({modkey}, 'Escape',
		function()
  	  awful.tag.history.restore()
    	_G._splash_to_current_tag()
		end, {
  	  description = 'go back',
	    group = 'Workspace / Tag'
	}),
-------------------------------
-------Workspace / Tag---------
-------------------------------
	awful.key({}, 'Print',
		function()
    	awful.util.spawn_with_shell(apps.default.screenshot_file)
		end, {
    	description = 'Save desktop screenshot to file',
	    group = 'Screenshot'
	}),
	awful.key({'Control'}, 'Print',
		function()
   		 awful.util.spawn_with_shell(apps.default.screenshot_clip)
		end, {
    	description = 'Save desktop screenshot to clipboard',
	    group = 'Screenshot'
	}),
	awful.key({'Control', 'Shift'}, 'Print',
		function()
    	awful.util.spawn_with_shell(apps.default.region_screenshot)
		end, {
  	  description = 'mark an area and screenshot it (clipboard)',
  	  group = 'Screenshot'
	}),
	awful.key({'Control',altkey}, 'Print', 
		function()
  	  awful.util.spawn_with_shell(apps.default.active_window_screenshot)
		end, {
  	  description = 'Screenshot active window to clipboard',
    	group = 'Screenshot'
	}),
--
-- Default client focus
--
awful.key({modkey}, 'd', function()
    awful.client.focus.byidx(1)
end, {
    description = 'focus next by index',
    group = 'client'
}),
awful.key({modkey}, 'a', function()
    awful.client.focus.byidx(-1)
end, {
    description = 'focus previous by index',
    group = 'client'
}),

awful.key({modkey}, 'u', function()
    awful.client.urgent.jumpto()
    _G._splash_to_current_tag()
end, {
    description = 'jump to urgent client',
    group = 'client'
}),
 awful.key({modkey}, 'k', function()
    awful.client.focus.byidx(1)
    if _G.client.focus then
        _G.client.focus:raise()
    end
end, {
    description = 'switch to next window',
    group = 'client'
}), 
awful.key({modkey}, 'j', function()
    awful.client.focus.byidx(-1)
    if _G.client.focus then
        _G.client.focus:raise()
    end
end, {
    description = 'switch to previous window',
    group = 'client'
}),
--
--Layout
-- 
 awful.key({altkey, 'Shift'}, 'Right', function()
    awful.tag.incmwfact(0.05)
end, {
    description = 'increase master width factor',
    group = 'layout'
}), awful.key({altkey, 'Shift'}, 'Left', function()
    awful.tag.incmwfact(-0.05)
end, {
    description = 'decrease master width factor',
    group = 'layout'
}), awful.key({altkey, 'Shift'}, 'Down', function()
    awful.client.incwfact(0.05)
end, {
    description = 'decrease master height factor',
    group = 'layout'
}), awful.key({altkey, 'Shift'}, 'Up', function()
    awful.client.incwfact(-0.05)
end, {
    description = 'increase master height factor',
    group = 'layout'
}), awful.key({modkey, 'Shift'}, 'Left', function()
    awful.tag.incnmaster(1, nil, true)
end, {
    description = 'increase the number of master clients',
    group = 'layout'
}), awful.key({modkey, 'Shift'}, 'Right', function()
    awful.tag.incnmaster(-1, nil, true)
end, {
    description = 'decrease the number of master clients',
    group = 'layout'
}), awful.key({modkey, 'Control'}, 'Left', function()
    awful.tag.incncol(1, nil, true)
end, {
    description = 'increase the number of columns',
    group = 'layout'
}), awful.key({modkey, 'Control'}, 'Right', function()
    awful.tag.incncol(-1, nil, true)
end, {
    description = 'decrease the number of columns',
    group = 'layout'
}), awful.key({modkey}, 'space', function()
    awful.layout.inc(1)
end, {
    description = 'select next layout',
    group = 'layout'
}), awful.key({modkey, 'Shift'}, 'space', function()
    awful.layout.inc(-1)
end, {
    description = 'select previous layout',
    group = 'layout'
}), awful.key({altkey, 'Shift'}, 'l', function()
    awful.tag.incmwfact(0.05)
end, {
    description = 'increase master width factor',
    group = 'layout'
}), awful.key({altkey, 'Shift'}, 'h', function()
    awful.tag.incmwfact(-0.05)
end, {
    description = 'decrease master width factor',
    group = 'layout'
}), awful.key({altkey, 'Shift'}, 'j', function()
    awful.client.incwfact(0.05)
end, {
    description = 'decrease master height factor',
    group = 'layout'
}), awful.key({altkey, 'Shift'}, 'k', function()
    awful.client.incwfact(-0.05)
end, {
    description = 'increase master height factor',
    group = 'layout'
}), awful.key({modkey, 'Shift'}, 'h', function()
    awful.tag.incnmaster(1, nil, true)
end, {
    description = 'increase the number of master clients',
    group = 'layout'
}), awful.key({modkey, 'Shift'}, 'l', function()
    awful.tag.incnmaster(-1, nil, true)
end, {
    description = 'decrease the number of master clients',
    group = 'layout'
}), awful.key({modkey, 'Control'}, 'h', function()
    awful.tag.incncol(1, nil, true)
end, {
    description = 'increase the number of columns',
    group = 'layout'
}), awful.key({modkey, 'Control'}, 'l', function()
    awful.tag.incncol(-1, nil, true)
end, {
    description = 'decrease the number of columns',
    group = 'layout'
}), 


awful.key({modkey}, 'o', awful.client.movetoscreen, {
    description = 'move window to next screen',
    group = 'client'
}))

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    -- Hack to only show tags 1 and 9 in the shortcut window (mod+s)
    local descr_view, descr_toggle, descr_move, descr_toggle_focus
    if i == 1 or i == 9 then
        descr_view = {
            description = 'view tag #',
            group = 'tag'
        }
        descr_toggle = {
            description = 'toggle tag #',
            group = 'tag'
        }
        descr_move = {
            description = 'move focused client to tag #',
            group = 'tag'
        }
        descr_toggle_focus = {
            description = 'toggle focused client on tag #',
            group = 'tag'
        }
    end
    globalKeys = awful.util.table.join(globalKeys, -- View tag only.
    awful.key({modkey}, '#' .. i + 9, function()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
            tag:view_only()
            _G._splash_to_current_tag()
        end
    end, descr_view), -- Toggle tag display.
    awful.key({modkey, 'Control'}, '#' .. i + 9, function()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
            awful.tag.viewtoggle(tag)
        end
    end, descr_toggle), -- Move client to tag.
    awful.key({modkey, 'Shift'}, '#' .. i + 9, function()
        if _G.client.focus then
            local tag = _G.client.focus.screen.tags[i]
            if tag then
                _G.client.focus:move_to_tag(tag)
            end
        end
    end, descr_move), -- Toggle tag on focused client.
    awful.key({modkey, 'Control', 'Shift'}, '#' .. i + 9, function()
        if _G.client.focus then
            local tag = _G.client.focus.screen.tags[i]
            if tag then
                _G.client.focus:toggle_tag(tag)
            end
        end
    end, descr_toggle_focus))
end

return globalKeys
