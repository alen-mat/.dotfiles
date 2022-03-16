{--
	This xmonad monster is an amalgam of
	- Default xmonad config
	- https://gitlab.com/dwt1/dotfiles
	- https://github.com/Axarva/dotfiles-2.0
	- https://github.com/xintron/configs/blob/22a33b41587c180172392f80318883921c543053/.xmonad/lib/Config.hs#L199
	- https://github.com/xintron/xmonad-log
--}

import Control.Monad ( join, when, replicateM_,liftM2)

import Data.Foldable ( traverse_ )
import Data.Maybe (maybeToList)
import Data.List (elemIndex)

import Graphics.X11.ExtraTypes.XF86

import System.Exit
import System.IO

import XMonad
import XMonad.Actions.CycleWS
import XMonad.Actions.DynamicProjects ( Project(..), dynamicProjects, switchProjectPrompt)
import XMonad.Actions.DynamicWorkspaces ( removeWorkspace )
import XMonad.Actions.FloatKeys ( keysAbsResizeWindow, keysResizeWindow)
import XMonad.Actions.GridSelect
import XMonad.Actions.Navigation2D
import XMonad.Actions.RotSlaves (rotSlavesUp)
import XMonad.Actions.SpawnOn
import XMonad.Actions.TagWindows
import XMonad.Actions.WindowGo (runOrRaise)
import XMonad.Actions.WithAll (killAll)

import XMonad.Config.Azerty
import XMonad.Config.Desktop

import Colors.Monnet


import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops ( ewmh, ewmhDesktopsEventHook)
import XMonad.Hooks.FadeInactive ( fadeInactiveLogHook )
import XMonad.Hooks.InsertPosition ( Focus(Newer), Position(Below), insertPosition)
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers ( (-?>), composeOne, doCenterFloat, doFullFloat, isDialog, isFullscreen, isInProperty)
import XMonad.Hooks.ScreenCorners
import XMonad.Hooks.SetWMName
import XMonad.Hooks.UrgencyHook ( UrgencyHook(..), withUrgencyHook)

import XMonad.Layout.BinarySpacePartition
import XMonad.Layout.BoringWindows (boringWindows, focusUp, focusDown)
import XMonad.Layout.CenteredMaster (centerMaster)
import XMonad.Layout.Cross (simpleCross)
import XMonad.Layout.Fullscreen (fullscreenEventHook, fullscreenManageHook, fullscreenSupport, fullscreenFull)
import XMonad.Layout.Gaps ( Direction2D(D, L, R, U), gaps, setGaps, GapMessage(DecGap, ToggleGaps, IncGap) )


import XMonad.Layout.IndependentScreens
import XMonad.Layout.LayoutModifier (ModifiedLayout)
import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit)
import XMonad.Layout.Maximize (maximize, maximizeRestore)
import XMonad.Layout.Minimize(minimize)
import XMonad.Layout.MultiToggle (Toggle(..), mkToggle, single, EOT(EOT), (??))
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Renamed
import XMonad.Layout.ResizableTile
import XMonad.Layout.SimpleFloat
import XMonad.Layout.ShowWName
import XMonad.Layout.Spacing ( Spacing, spacingRaw, Border(Border) )
import XMonad.Layout.Spiral (spiral)
import XMonad.Layout.SubLayouts
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns
import XMonad.Layout.ToggleLayouts (toggleLayouts, ToggleLayout(Toggle))
import XMonad.Layout.WindowArranger (windowArrange, WindowArrangerMsg(..))
import XMonad.Layout.WindowNavigation


import XMonad.Prompt ( defaultXPConfig, XPConfig(..), XPPosition(CenteredAt))

import XMonad.Util.EZConfig (additionalKeys, additionalMouseBindings)
import XMonad.Util.NamedScratchpad ( NamedScratchpad(..), customFloating, defaultFloating, namedScratchpadAction, namedScratchpadManageHook)
import XMonad.Util.NamedActions ((^++^), NamedAction (..), addDescrKeys', addName, showKm, subtitle)
import XMonad.Util.Run (safeSpawn,spawnPipe)
import XMonad.Util.SpawnOnce
import XMonad.Util.WorkspaceCompare ( getSortByIndex )

import qualified Codec.Binary.UTF8.String as UTF8
import qualified Control.Exception as E
import qualified DBus as D
import qualified DBus.Client as D
import qualified Data.ByteString as B
import qualified Data.Map as M
import qualified XMonad.Layout.ToggleLayouts as T
import qualified XMonad.Layout.MultiToggle as MT
import qualified XMonad.StackSet as W
import qualified XMonad.Util.NamedWindows as W

{--
Run X () actions by touching the edge of your screen with your mouse
https://wiki.archlinux.org/title/xmonad#Controlling_xmonad_with_external_scripts
--}
myColorizer :: Window -> Bool -> X (String, String)
myColorizer = colorRangeFromClassName
                  (0x28,0x2c,0x34) -- lowest inactive bg
                  (0x28,0x2c,0x34) -- highest inactive bg
                  (0xc7,0x92,0xea) -- active bg
                  (0xc0,0xa7,0x9a) -- inactive fg
                  (0x28,0x2c,0x34) -- active fg

-- gridSelect menu layout
mygridConfig :: p -> GSConfig Window
mygridConfig colorizer = (buildDefaultGSConfig myColorizer)
    { gs_cellheight   = 40
    , gs_cellwidth    = 200
    , gs_cellpadding  = 6
    , gs_originFractX = 0.5
    , gs_originFractY = 0.5
    , gs_font         = myFont
    }

spawnSelected' :: [(String, String)] -> X ()
spawnSelected' lst = gridselect conf lst >>= flip whenJust spawn
    where conf = def
                   { gs_cellheight   = 40
                   , gs_cellwidth    = 200
                   , gs_cellpadding  = 6
                   , gs_originFractX = 0.5
                   , gs_originFractY = 0.5
                   , gs_font         = myFont
                   }

myAppGrid = [ ("Audacity", "audacity")
                 , ("Deadbeef", "deadbeef")
                 , ("Emacs", "emacsclient -c -a emacs")
                 , ("Firefox", "firefox")
                 , ("Geany", "geany")
                 , ("Geary", "geary")
                 , ("Gimp", "gimp")
                 , ("Kdenlive", "kdenlive")
                 , ("LibreOffice Impress", "loimpress")
                 , ("LibreOffice Writer", "lowriter")
                 , ("OBS", "obs")
                 , ("PCManFM", "pcmanfm")
                 ]

------------------------------------------------------------------------
------------------------------------------------------------------------
myFont :: String
myFont = "xft:SauceCodePro Nerd Font Mono:regular:size=9:antialias=true:hinting=true"

myBaseConfig = desktopConfig
myTerminal      = "kitty"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses =  True

-- Width of the window border in pixels.
--
myBorderWidth   = 2

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
---mod4Mask= super key
--mod1Mask= alt key
--controlMask= ctrl key
--shiftMask= shift key

altMask = mod1Mask
myModMask       = mod4Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
webWs = "1" --"web"
ossWs = "2" --"oss"
devWs = "3" --"dev"
comWs = "4" --"com"
wrkWs = "5" --"wrk"
sysWs = "6" --"sys"
etcWs = "7" --"etc"
myWorkspaces :: [WorkspaceId]
myWorkspaces = [webWs,ossWs,devWs,comWs,wrkWs,sysWs,etcWs,"8","9"]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor :: String
myNormalBorderColor   = colorBack

myFocusedBorderColor :: String
myFocusedBorderColor  = color14

toggleFullScreen = do
      sendMessage $ MT.Toggle $ FULL
      sendMessage $ ToggleGaps


------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
-- https://wiki.linuxquestions.org/wiki/XF86_keyboard_symbols
--

showKeybindings :: [((KeyMask, KeySym), NamedAction)] -> NamedAction
showKeybindings x = addName "Show Keybindings" . io $
  E.bracket (spawnPipe $ getAppCommand yad) hClose (\h -> hPutStr h (unlines $ showKm x))

myKeys conf@XConfig {XMonad.modMask = modm} =
  keySet "Launchers"
    [ key "Terminal"                 (modm .|. shiftMask  , xK_Return) $ spawn (XMonad.terminal conf)
    , key "Apps (Rofi)"              (modm                , xK_p     ) $ spawn $ "~/.local/bin/rofi_helper -a"
    , key "Bluetooth Manager (Rofi)" (modm ,xK_bracketleft           ) $ spawn $ "~/.local/bin/rofi_helper -bm"
    , key "Network Manager (Rofi)"   (modm ,xK_bracketright          ) $ spawn $ "~/.local/bin/rofi_helper -nm"
    , key "Power Menu (Rofi)"        (modm ,xK_semicolon             ) $ spawn $ "~/.local/bin/rofi_helper -p"
    , key "ClipBoard (Rofi)"         (modm ,xK_v) $ spawn $ "~/.local/bin/rofi_helper -gc"
    , key "Lock screen (Rofi)"       (modm .|. controlMask, xK_l     ) $ spawn $ "betterlockscreen -l"
    , key "Bitwarden (Rofi)"         (modm .|. controlMask .|. altMask ,xK_slash) $ spawn $ "~/.local/bin/rofi_helper -bw"
    ] ^++^
  keySet "Audio"
    [ key "Mute"          (0, xF86XK_AudioMicMute           ) $ spawn "amixer -q set Capture toggle"
    , key "Mute"          (0, xF86XK_AudioMute              ) $ spawn "amixer -q set Master toggle"
    , key "Lower volume"  (0, xF86XK_AudioLowerVolume       ) $ spawn "amixer -q set Master 5%-"
    , key "Raise volume"  (0, xF86XK_AudioRaiseVolume       ) $ spawn "amixer -q set Master 5%+"
    , key "Play / Pause"  (0, xF86XK_AudioPlay              ) $ spawn $ "playerctl play-pause && echo 'play-pause' | ~/.local/bin/usr_notification_helper media"
    , key "Stop"          (0, xF86XK_AudioStop              ) $ spawn $ "playerctl stop && echo 'Stopped' | ~/.local/bin/usr_notification_helper media"
    , key "Previous"      (0, xF86XK_AudioPrev              ) $ spawn $ "playerctl previous && echo 'Now Playing' | ~/.local/bin/usr_notification_helper media"
    , key "Next"          (0, xF86XK_AudioNext              ) $ spawn $ "playerctl next && echo 'Now Playing' | ~/.local/bin/usr_notification_helper media"
    ] ^++^
  keySet "Brigtness"
    [ key "Increase brigtness"  (0, xF86XK_MonBrightnessUp  ) $  spawn $ "xbacklight -inc 5 && xbacklight -g | ~/.local/bin/usr_notification_helper brightness"
    , key "Decrease brightness" (0, xF86XK_MonBrightnessDown) $  spawn $ "xbacklight -dec 2 && xbacklight -g | ~/.local/bin/usr_notification_helper brightness"
    ] ^++^
  keySet "Fn Keys"
    [ key "Homepage"   (0, xF86XK_HomePage  ) $ spawn "brave"
    , key "Search"     (0, xF86XK_Search    ) $ spawn "dmsearch"
    , key "Mail"       (0, xF86XK_Mail      ) $ runOrRaise "thunderbird" (resource =? "thunderbird")
    , key "Calculator" (0, xF86XK_Calculator) $ runOrRaise "qalculate-gtk" (resource =? "qalculate-gtk")
    , key "Eject"      (0, xF86XK_Eject     ) $ spawn "toggleeject"
    ] ^++^
  keySet "Scratchpads"
    [ key "Audacious"       (modm .|. controlMask,  xK_a    ) $ runScratchpadApp audacious
    , key "bottom"          (modm .|. controlMask,  xK_y    ) $ runScratchpadApp btm
    , key "Files"           (modm .|. controlMask,  xK_f    ) $ runScratchpadApp nautilus
    , key "Screen recorder" (modm .|. controlMask,  xK_r    ) $ runScratchpadApp scr
    , key "Spotify"         (modm .|. controlMask,  xK_s    ) $ runScratchpadApp spotify
    ] ^++^
  keySet "System"
    [ key "Toggle status bar gap"          (modm                      , xK_b )     toggleStruts
    , key "Logout (quit XMonad)"           (modm .|. shiftMask        , xK_q )     $ io exitSuccess
    , key "Restart XMonad"                 (modm                      , xK_q )     $ spawn "xmonad --recompile; xmonad --restart"
    , key "Capture entire screen to file"  (modm                      , xK_Print)  $ spawn "flameshot full -p ~/Pictures/Screenshots/"
    , key "Capture entire screen to clip"  (controlMask               , xK_Print)  $ spawn "flameshot full -c"
    , key "Capture partial screen to clip" (controlMask .|. shiftMask , xK_Print)  $ spawn "flameshot gui"
    ] ^++^
  keySet "Layouts"
    [ key "Next"                (modm              , xK_space ) $ sendMessage NextLayout
    , key "Reset"               (modm .|. shiftMask, xK_space ) $ setLayout (XMonad.layoutHook conf)
    , key "Fullscreen"          (modm              , xK_f     ) $ sendMessage (MT.Toggle NBFULL)
    , key "Fullscreen Hide bar" (modm .|. shiftMask, xK_f     ) $ toggleFullScreen
    ] ^++^
  keySet "Windows"
    [ key "Close focused"   (modm              , xK_BackSpace) kill
    , key "Close all in ws" (modm .|. shiftMask, xK_BackSpace) killAll
    , key "Refresh size"    (modm              , xK_n        ) refresh
    , key "Focus next"      (modm              , xK_j        ) $ windows W.focusDown
    , key "Focus previous"  (modm              , xK_k        ) $ windows W.focusUp
    , key "Focus master"    (modm              , xK_m        ) $ windows W.focusMaster
    , key "Swap master"     (modm              , xK_Return   ) $ windows W.swapMaster
    , key "Swap next"       (modm .|. shiftMask, xK_j        ) $ windows W.swapDown
    , key "Swap previous"   (modm .|. shiftMask, xK_k        ) $ windows W.swapUp
    , key "Shrink master"   (modm              , xK_h        ) $ sendMessage Shrink
    , key "Expand master"   (modm              , xK_l        ) $ sendMessage Expand
    , key "Switch to tile"  (modm              , xK_t        ) $ withFocused (windows . W.sink)
    , key "Rotate slaves"   (modm .|. shiftMask, xK_Tab      ) rotSlavesUp
    , key "Decrease size"   (modm              , xK_d        ) $ withFocused (keysResizeWindow (-10,-10) (1,1))
    , key "Increase size"   (modm              , xK_s        ) $ withFocused (keysResizeWindow (10,10) (1,1))
    , key "Decr  abs size"  (modm .|. shiftMask, xK_d        ) $ withFocused (keysAbsResizeWindow (-10,-10) (1024,752))
    , key "Incr  abs size"  (modm .|. shiftMask, xK_s        ) $ withFocused (keysAbsResizeWindow (10,10) (1024,752))
    ] ^++^
  keySet "Tag Windows"
    [ key "" (modm,                    xK_g ) $ tagPrompt myXPConfig (\ s -> withFocused (addTag s))
    , key "" (modm .|. controlMask,    xK_g ) $ tagDelPrompt myXPConfig
    , key "" (modm .|. shiftMask,      xK_g ) $ tagPrompt myXPConfig (\s -> withTaggedGlobal s float)
    , key "" (altMask,                 xK_g ) $ tagPrompt myXPConfig (\s -> withTaggedP s (W.shiftWin "2"))
    , key "" (altMask .|. shiftMask,   xK_g ) $ tagPrompt myXPConfig (\s -> withTaggedGlobalP s shiftHere)
    , key "" (altMask .|. controlMask, xK_g ) $ tagPrompt myXPConfig (\s -> focusUpTaggedGlobal s)
    ] ^++^
  keySet "Bar & Widgets"
    [ key "Polybar Toggle"           (modm , xK_equal ) togglePolybar
    , key "Eww widget Toggle"        (modm , xK_minus ) $ spawn "~/.config/eww/launch_eww"
    ] ^++^
  keySet "Projects"
    [ key "Switch prompt" (modm              , xK_o         ) $ switchProjectPrompt myXPConfig
    ] ^++^
  keySet "Screens" switchScreen ^++^
  keySet "Workspaces"
    [ key "Next"          (modm              , xK_period    ) nextWS'
    , key "Previous"      (modm              , xK_comma     ) prevWS'
    , key "Remove"        (modm .|. shiftMask, xK_F4        ) removeWorkspace
    ] ++ switchWsById
  where
    togglePolybar = spawn "polybar-msg cmd toggle &" >> toggleFullScreen
    toggleStruts = togglePolybar >> sendMessage ToggleStruts
    keySet s ks = subtitle s : ks
    key n k a = (k, addName n a)
    action m = if m == shiftMask then "Move to " else "Switch to "
    -- mod-[1..9]: Switch to workspace N | mod-shift-[1..9]: Move client to workspace N
    switchWsById =
      [ key (action m <> show i) (m .|. modm, k) (windows $ f i)
          | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
          , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    switchScreen =
      [ key (action m <> show sc) (m .|. modm, k) (screenWorkspace sc >>= flip whenJust (windows . f))
          | (k, sc) <- zip [xK_w, xK_e, xK_r] [0..]
          , (f, m)  <- [(W.view, 0), (W.shift, shiftMask)]]

----------- Cycle through workspaces one by one but filtering out NSP (scratchpads) -----------

nextWS' = switchWS Next
prevWS' = switchWS Prev

switchWS dir =
  findWorkspace filterOutNSP dir AnyWS 1 >>= windows . W.view

filterOutNSP =
  let g f xs = filter (\(W.Workspace t _ _) -> t /= "NSP") (f xs)
  in  g <$> getSortByIndex


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
--Keeps window on top of polybar
addNETSupported :: Atom -> X ()
addNETSupported x   = withDisplay $ \dpy -> do
    r               <- asks theRoot
    a_NET_SUPPORTED <- getAtom "_NET_SUPPORTED"
    a               <- getAtom "ATOM"
    liftIO $ do
       sup <- (join . maybeToList) <$> getWindowProperty32 dpy a_NET_SUPPORTED r
       when (fromIntegral x `notElem` sup) $
         changeProperty32 dpy r a_NET_SUPPORTED a propModeAppend [fromIntegral x]

addEWMHFullscreen :: X ()
addEWMHFullscreen   = do
    wms <- getAtom "_NET_WM_STATE"
    wfs <- getAtom "_NET_WM_STATE_FULLSCREEN"
    mapM_ addNETSupported [wms, wfs]


------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
mySpacing :: Integer -> l a -> ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border 0 i 0 i) True (Border i 0 i 0) True

fullscreenLayout = renamed [PrependWords "fullscreen"]
                   ( noBorders $ Full )

myShowWNameTheme :: SWNConfig
myShowWNameTheme = def
    { swn_font              = "xft:Ubuntu:bold:size=60"
    , swn_fade              = 1.0
    , swn_bgcolor           = "#1c1f24"
    , swn_color             = "#ffffff"
    }


defaultLayouts = renamed [PrependWords "Default"] tiled ||| Mirror tiled ||| Full
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = mySpacing 5
               $ mkToggle (NOBORDERS ?? FULL ?? EOT)
               $ addTabs shrinkText myTabTheme
               $ Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100
     tiled_ratio = 1/2

myLayout = gaps [(U,35), (D,5), (R,5), (L,5)] $ smartBorders ( defaultLayouts )

myTabTheme = def { fontName            = myFont
                 , activeColor         = color14
                 , inactiveColor       = color7
                 , activeBorderColor   = color14
                 , inactiveBorderColor = colorBack
                 , activeTextColor     = colorBack
                 , inactiveTextColor   = color15
                 }

-- myLayoutHook = showWName' myShowWNameTheme $ myLayout
myLayoutHook = screenCornerLayoutHook $ myLayout

-- Set default layout per workSpace
-- myLayout = onWorkspaces ["4"] simpleFloat $ defaultLayouts

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--

type AppName      = String
type AppTitle     = String
type AppClassName = String
type AppCommand   = String

data App
  = ClassApp AppClassName AppCommand
  | TitleApp AppTitle AppCommand
  | NameApp AppName AppCommand
  deriving Show

audacious = ClassApp "Audacious"            "audacious"
btm       = TitleApp "btm"                  "alacritty -t btm -e btm --color gruvbox --default_widget_type proc"
calendar  = ClassApp "Gnome-calendar"       "gnome-calendar"
eog       = NameApp  "eog"                  "eog"
evince    = ClassApp "Evince"               "evince"
gimp      = ClassApp "Gimp"                 "gimp"
nautilus  = ClassApp "Org.gnome.Nautilus"   "nautilus"
office    = ClassApp "libreoffice-draw"     "libreoffice-draw"
pavuctrl  = ClassApp "Pavucontrol"          "pavucontrol"
scr       = ClassApp "SimpleScreenRecorder" "simplescreenrecorder"
spotify   = ClassApp "Spotify"              "myspotify"
vlc       = ClassApp "Vlc"                  "vlc"
yad       = ClassApp "Yad"                  "yad --text-info --text 'XMonad'"

myManageHook =  manageApps <+> manageSpawn <+> manageScratchpads
 where
  isBrowserDialog     = isDialog <&&> className =? "Brave-browser"
  isFileChooserDialog = isRole =? "GtkFileChooserDialog"
  isPopup             = isRole =? "pop-up"
  isSplash            = isInProperty "_NET_WM_WINDOW_TYPE" "_NET_WM_WINDOW_TYPE_SPLASH"
  isRole              = stringProperty "WM_WINDOW_ROLE"
  tileBelow           = insertPosition Below Newer
  doCalendarFloat   = customFloating (W.RationalRect (11 / 15) (1 / 48) (1 / 4) (1 / 4))
  manageScratchpads = namedScratchpadManageHook scratchpads
  anyOf :: [Query Bool] -> Query Bool
  anyOf = foldl (<||>) (pure False)
  match :: [App] -> Query Bool
  match = anyOf . fmap isInstance
  manageApps = composeOne
    [ isInstance calendar                      -?> doCalendarFloat
    , match [ gimp, office ]                   -?> doFloat
    , match [ audacious
            , eog
            , nautilus
            , pavuctrl
            , scr
            ]                                  -?> doCenterFloat
    , match [ btm, evince, spotify, vlc, yad ] -?> doFullFloat
    , resource =? "desktop_window"             -?> doIgnore
    , resource =? "kdesktop"                   -?> doIgnore
    , anyOf [ isBrowserDialog
            , isFileChooserDialog
            , isDialog
            , isPopup
            , isSplash
            ]                                  -?> doCenterFloat
    , title =? "Picture in picture" -?> doFloat
		, className =? "fluent-reader"  -?> doFloat
    , (className =? "firefox" <&&> (resource =? "Toolkit" <||> resource =? "Dialog"))  -?> doFloat
    , isFullscreen                             -?> doFullFloat
    , pure True                                -?> tileBelow
    ]

isInstance (ClassApp c _) = className =? c
isInstance (TitleApp t _) = title =? t
isInstance (NameApp n _)  = appName =? n

getNameCommand (ClassApp n c) = (n, c)
getNameCommand (TitleApp n c) = (n, c)
getNameCommand (NameApp  n c) = (n, c)

getAppName    = fst . getNameCommand
getAppCommand = snd . getNameCommand

scratchpadApp :: App -> NamedScratchpad
scratchpadApp app = NS (getAppName app) (getAppCommand app) (isInstance app) defaultFloating

runScratchpadApp = namedScratchpadAction scratchpads . getAppName

scratchpads = scratchpadApp <$> [ audacious, btm, nautilus, scr, spotify]


------------------------------------------------------------------------
-- Dynamic Projects
--
projects :: [Project]
projects =
  [ Project { projectName      = webWs
            , projectDirectory = "~/"
            , projectStartHook = Just $ spawn "firefox -P 'default'"
            }
  , Project { projectName      = ossWs
            , projectDirectory = "~/"
            , projectStartHook = Just $ do replicateM_ 2 (spawn myTerminal)
                                           spawn $ myTerminal <> " -e home-manager edit"
            }
  , Project { projectName      = devWs
            , projectDirectory = "~/workspace/trading"
            , projectStartHook = Just . replicateM_ 8 $ spawn myTerminal
            }
  , Project { projectName      = comWs
            , projectDirectory = "~/"
            , projectStartHook = Just $ do spawn "telegram-desktop"
                                           spawn "signal-desktop --use-tray-icon"
            }
  , Project { projectName      = wrkWs
            , projectDirectory = "~/"
            , projectStartHook = Just $ spawn "firefox -P 'demo'" -- -no-remote"
            }
  , Project { projectName      = sysWs
            , projectDirectory = "/etc/nixos/"
            , projectStartHook = Just . spawn $ myTerminal <> " -e sudo su"
            }
  , Project { projectName      = etcWs
            , projectDirectory = "~/workspace"
            , projectStartHook = Just . spawn $ myTerminal
            }
  ]
-----------------------------------------------------------------------
--Config for Xmonad prompt

myXPConfig :: XPConfig
myXPConfig = def
  { bgHLight = color4
  , bgColor = color0
  , fgColor = color1
  , fgHLight = color2
  , borderColor= color13
  , font     = "xft:Bitstream Vera Sans Mono:size=8:antialias=true"
  , height   = 50
  , position = CenteredAt 0.5 0.5
  }

-----------------------------------------------------------------------
-- original idea: https://pbrisbin.com/posts/using_notify_osd_for_xmonad_notifications/
data LibNotifyUrgencyHook = LibNotifyUrgencyHook deriving (Read, Show)

instance UrgencyHook LibNotifyUrgencyHook where
  urgencyHook LibNotifyUrgencyHook w = do
    name     <- W.getName w
    maybeIdx <- W.findTag w <$> gets windowset
    traverse_ (\i -> safeSpawn "notify-send" [show name, "workspace " ++ i]) maybeIdx

-----------------------------------------------------------------------
-- Polybar settings (needs DBus client).
--
mkDbusClient :: IO D.Client
mkDbusClient = do
  dbus <- D.connectSession
  D.requestName dbus (D.busName_ "org.xmonad.log") opts
  return dbus
 where
  opts = [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]

-- Emit a DBus signal on log updates
dbusOutput :: D.Client -> String -> IO ()
dbusOutput dbus str =
  let opath  = D.objectPath_ "/org/xmonad/Log"
      iname  = D.interfaceName_ "org.xmonad.Log"
      mname  = D.memberName_ "Update"
      signal = D.signal opath iname mname
      body   = [D.toVariant $ UTF8.decodeString str]
  in  D.emit dbus $ signal { D.signalBody = body }

polybarHook :: D.Client -> PP
polybarHook dbus =
  let wrapper c s | s /= "NSP" = wrap ("%{F" <> c <> "} ") " %{F-}" s
                  | otherwise  = mempty
      blue   = "#2E9AFE"
      gray   = "#7F7F7F"
      orange = "#ea4300"
      purple = "#9058c7"
      red    = "#722222"
  in  def { ppOutput          = dbusOutput dbus
            ,ppOrder            = \(_:l:_:_) -> [l]
          --, ppCurrent         = wrapper blue
          --, ppVisible         = wrapper gray
          --, ppUrgent          = wrapper orange
          --, ppHidden          = wrapper gray
          --, ppHiddenNoWindows = wrapper red
          --, ppTitle           = wrapper purple . shorten 90
          }

myPolybarLogHook dbus = myLogHook <+> dynamicLogWithPP (polybarHook dbus)


------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = do
               handleEventHook myBaseConfig <+> fullscreenEventHook <+> docksEventHook <+> ewmhDesktopsEventHook <+> screenCornerEventHook

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
-- myLogHook = return ()
myLogHook = fadeInactiveLogHook 0.9

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = do
  spawnOnce "~/.local/bin/autostart.sh bar"
  setWMName "XMonad"
  addScreenCorners [ (SCLowerLeft,  prevWS)
                   , (SCLowerRight, nextWS)
                   , (SCUpperLeft, spawnSelected' myAppGrid)
                   , (SCUpperRight, goToSelected $ mygridConfig myColorizer)
                 ]
------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
-- main = xmonad defaults

main :: IO ()
main = mkDbusClient >>= main'

main' :: D.Client -> IO ()
main' dbus = xmonad . docks . ewmh . dynProjects . keybindings . urgencyHook$ fullscreenSupport $ def {
  terminal           = myTerminal,
  focusFollowsMouse  = myFocusFollowsMouse,
  clickJustFocuses   = myClickJustFocuses,
  borderWidth        = myBorderWidth,
  modMask            = myModMask,
  workspaces         = myWorkspaces,
  normalBorderColor  = myNormalBorderColor,
  focusedBorderColor = myFocusedBorderColor,

  mouseBindings      = myMouseBindings,

  layoutHook         = myLayoutHook,
  manageHook         = manageSpawn <+> manageDocks <+> fullscreenManageHook  <+> myManageHook <+> manageHook myBaseConfig,
  handleEventHook    = myEventHook,
  logHook            = myPolybarLogHook dbus,
  startupHook        = myStartupHook >> addEWMHFullscreen
  }
  where
    dynProjects = dynamicProjects projects
    logHook     = myPolybarLogHook dbus
    keybindings = addDescrKeys' ((myModMask, xK_F1), showKeybindings) myKeys
    urgencyHook = withUrgencyHook LibNotifyUrgencyHook

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
