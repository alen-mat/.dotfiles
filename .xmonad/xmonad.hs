import XMonad

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.DynamicProperty
import XMonad.Hooks.FadeInactive 
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.Rescreen
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP

import XMonad.Util.EZConfig
import XMonad.Util.Loggers
import XMonad.Util.Ungrab

import XMonad.Layout.Magnifier
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed
import XMonad.Layout.ThreeColumns

import XMonad.Operations(withFocused)
import XMonad.Util.Hacks as Hacks

import XMonad.StackSet as SS
import XMonad.ManageHook
import XMonad.Util.NamedScratchpad

import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks

edit :: String -> X ()
edit = spawn . ("neovide " ++)

workspacen :: [String]
workspacen =  ["irc", "refs", "pending", "win10", "games", "tv", "calibre", "misc", "spare"]

main :: IO ()
main = xmonad
     . docks
     . Hacks.javaHack
     . addAfterRescreenHook (spawn "autorandr --change" >> spawn "feh --bg-fill ~/Pictures/new-walls/wallhaven-landscape.jpg")
     . ewmhFullscreen
     . ewmh
     $ myConfig

myConfig = def
    { modMask    = mod4Mask      -- Rebind Mod to the Super key
    , logHook    = fILogHook   
    , layoutHook = myLayout      -- Use custom layouts
    , manageHook = myManageHook  -- Match on certain windows
    , handleEventHook = dynamicPropertyChange "WM_NAME" myDynamicManageHook <>  myHandleEventHook 
    , XMonad.workspaces  = workspacen
    }
  `additionalKeysP`
    [ ("M-<Return>"  , spawn "wezterm" )
    , ("M-e x", edit "~/.xmonad"        )
    , ("M-e n", edit "~/workspace/notes")
    , ("M-o"  , spawn $ "~/.local/bin/rofi_helper -a")
    , ("M-t"  , withFocused $ windows . SS.sink)

    , ("<XF86MonBrightnessUp>" , spawn "brightnessctl set +1%")
    , ("<XF86MonBrightnessDown>" , spawn "brightnessctl set 1%-")

    , ("<XF86AudioMicMute>", spawn $ "~/.scripts/notify/audio --mic-toggle")
    , ("<XF86AudioMute>", spawn $ "~/.scripts/notify/audio --spkr-toggle")
    , ("<XF86AudioLowerVolume>", spawn $ "~/.scripts/notify/audio --spkr-d")
    , ("<XF86AudioRaiseVolume>", spawn $ "~/.scripts/notify/audio --spkr-i")
    
    , ("<XF86AudioPlay>", spawn $ "~/.scripts/notify/media --pp")
    , ("<XF86AudioStop>", spawn $ "~/.scripts/notify/media --stop")
    , ("<XF86AudioPrev>", spawn $ "~/.scripts/notify/media --prev")
    , ("<XF86AudioNext>", spawn $ "~/.scripts/notify/media --next")

    , ("M-S-s", namedScratchpadAction scratchpads "Spotify")
    , ("M-S-n", namedScratchpadAction scratchpads "Notes")
 
    , ("M-<Backspace>", kill)
    ]


fILogHook   :: X ()
fILogHook  = fadeInactiveLogHook fadeAmount
    where fadeAmount = 0.86

myManageHook :: ManageHook
myManageHook = manageZoomHook <+> otherManageHook

otherManageHook :: ManageHook
otherManageHook = composeAll
    [ className =? "Gimp" --> doFloat
    , isDialog            --> doFloat
    , checkDock           --> doLower
    ]

manageZoomHook =
  composeAll $
    [ (className =? zoomClassName) <&&> shouldFloat <$> title --> doFloat,
      (className =? zoomClassName) <&&> shouldSink <$> title --> doSink
    ]
  where
    zoomClassName = "zoom"
    tileTitles =
      [ "Zoom - Free Account", -- main window
        "Zoom - Licensed Account", -- main window
        "Zoom", -- meeting window on creation
        "Zoom Meeting" -- meeting window shortly after creation
      ]
    shouldFloat title = title `notElem` tileTitles
    shouldSink title = title `elem` tileTitles
    doSink = (ask >>= doF . SS.sink) <+> doF SS.swapDown

myLayout = smartBorders $ avoidStruts(tiled ||| Mirror tiled ||| threeCol) ||| noBorders Full 
  where
    threeCol = renamed [Replace "ThreeCol"]
             $ magnifiercz' 1.3
             $ ThreeColMid nmaster delta ratio
    tiled    = Tall nmaster delta ratio
    nmaster  = 1      -- Default number of windows in the master pane
    ratio    = 1/2    -- Default proportion of screen occupied by master pane
    delta    = 3/100  -- Percent of screen to increment by when resizing panes


myHandleEventHook =
  mconcat
    [ dynamicTitle manageZoomHook
    ]

myDynamicManageHook :: ManageHook
myDynamicManageHook =
 composeAll
   [ className =? "Spotify" --> doShift (workspacen !! 4)
   ]

scratchpads = [
    NS "btop" "wezterm start -- btop" (title =? "btop") defaultFloating ,
    NS "Spotify" "spotify" (title =? "[Ss]potiy")
        (customFloating $ SS.RationalRect (1/6) (1/6) (2/3) (2/3)) ,
    NS "Notes" "neovide ~/workspace/notes --x11-wm-class notes" (className =? "notes") nonFloating
    ] where role = stringProperty "WM_WINDOW_ROLE"
