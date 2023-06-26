local awful            = require("awful")
local hotkeys_popup    = require("awful.hotkeys_popup")
local menubar          = require("menubar")
local wibox            = require("wibox")
local beautiful        = require("beautiful")
local gears            = require("gears")
local tray             = require('widgets.tray-toggle')
local battery          = require('widgets.battery')
local network          = require('widgets.network')
local dpi              = require('beautiful').xresources.apply_dpi
local taglist          = require("widgets.taglist")
local tasklist         = require("widgets.tasklist")
local calendar         = require("widgets.orglender")
-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu          = {
    { "hotkeys",     function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
    { "manual",      terminal .. " -e man awesome" },
    { "edit config", editor_cmd .. " " .. awesome.conffile },
    { "restart",     awesome.restart },
    { "quit",        function() awesome.quit() end },
}

local mymainmenu       = awful.menu({
    items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
        { "open terminal", terminal }
    }
})

local mylauncher       = awful.widget.launcher({
    image = beautiful.awesome_icon,
    menu = mymainmenu
})

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
local mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
local mytextclock      = wibox.widget.textclock()
calendar.register(mytextclock)


-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end)
--      awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
--     awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)


local function create_bar(s)
    -- Each screen has its own tag table.
    s.tray_toggle = tray.toggle
    s.systray     = tray.widget
    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
        awful.button({}, 1, function() awful.layout.inc(1) end),
        awful.button({}, 3, function() awful.layout.inc(-1) end),
        awful.button({}, 4, function() awful.layout.inc(1) end),
        awful.button({}, 5, function() awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, bg = '#0000' })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,

        {
            -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,

            --s.mytaglist,

            taglist(s),
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        --    {
        --        tasklist(s),
        --        valign = "center",
        --        halign = "center",
        --        layout = wibox.container.place
        --    },
        {
            -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            {
                s.systray,
                margins = dpi(0),
                widget = wibox.container.margin,
            },
            s.tray_toggle,
            network,
            mykeyboardlayout,
            mytextclock,
            battery,
            s.mylayoutbox,
        },
    }
end
-- }}}
--
return create_bar
