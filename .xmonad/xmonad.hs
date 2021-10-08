import Control.Monad ( join, when )
import Control.Monad (liftM2)

import Data.Maybe (maybeToList)

import Graphics.X11.ExtraTypes.XF86

import System.Exit
import System.IO

import XMonad
import XMonad.Actions.CycleWS
import XMonad.Actions.Navigation2D
import XMonad.Actions.SpawnOn
import XMonad.Actions.WindowGo (runOrRaise)

import XMonad.Config.Azerty
import XMonad.Config.Desktop

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops ( ewmh, ewmhDesktopsEventHook)
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers (doFullFloat, doCenterFloat, isFullscreen, isDialog)
import XMonad.Hooks.SetWMName
import XMonad.Hooks.UrgencyHook

import XMonad.Layout.BinarySpacePartition
import XMonad.Layout.BoringWindows (boringWindows, focusUp, focusDown)
import XMonad.Layout.CenteredMaster (centerMaster)
import XMonad.Layout.Cross (simpleCross)
import XMonad.Layout.Fullscreen (fullscreenEventHook, fullscreenManageHook, fullscreenSupport, fullscreenFull)
import XMonad.Layout.Gaps
import XMonad.Layout.IndependentScreens
import XMonad.Layout.LayoutModifier (ModifiedLayout)
import XMonad.Layout.Maximize (maximize, maximizeRestore)
import XMonad.Layout.Minimize(minimize)
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Renamed
import XMonad.Layout.ResizableTile
import XMonad.Layout.SimpleFloat
import XMonad.Layout.Spacing ( Spacing, spacingRaw, Border(Border) )
import XMonad.Layout.Spiral (spiral)
import XMonad.Layout.ThreeColumns

import XMonad.Util.EZConfig (additionalKeys, additionalMouseBindings)
import XMonad.Util.Run (spawnPipe)
import XMonad.Util.SpawnOnce

import qualified Codec.Binary.UTF8.String as UTF8
import qualified DBus as D
import qualified DBus.Client as D
import qualified Data.ByteString as B
import qualified Data.Map as M
import qualified XMonad.StackSet as W

normBord = "#4f4f4f"
focdBord = "#00B19F"
fore     = "#DEE3E0"
back     = "#282c34"
winType  = "#c678dd"

--mod4Mask= super key
--mod1Mask= alt key
--controlMask= ctrl key
--shiftMask= shift key

myBaseConfig = desktopConfig
myTerminal      = "alacritty"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
--
myBorderWidth   = 2

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
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
myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#dddddd"
myFocusedBorderColor = "#ff0000"


toggleFullScreen = do
      sendMessage $ Toggle $ FULL
      sendMessage $ ToggleGap U


------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    -- launch gmrun
    , ((modm .|. shiftMask, xK_p     ), spawn "gmrun")

    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_r     ), refresh)

    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm,               xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Full screen
    , ((modm, xK_f), sendMessage $Toggle FULL)
    , ((modm .|. shiftMask, xK_f), toggleFullScreen)
    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    , ((modm              , xK_b     ), sendMessage ToggleStruts)

    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")

    -- Application menu
    , ((modm ,xK_p ),spawn "~/.config/rofi/applets/app_launcher.sh" )

    -- bluetooth menu
    , ((modm ,xK_bracketleft),spawn "~/.config/rofi/applets/bluetooth-manager.sh" )

    -- Network
    , ((modm ,xK_bracketright),spawn ("~/.config/rofi/applets/network-manager.sh" ))

    -- launch power menu
    , ((modm ,xK_semicolon), spawn ("~/.config/rofi/applets/powermenu.sh"))

    -- Lock
    , ((modm .|. shiftMask, xK_x), spawn "betterlockscreen -l")

    -- Emacs
    , ((modm .|. shiftMask, xK_h), spawn "emacsclient --create-frame")

    --MULTIMEDIA KEYS

    -- Mute volume
    , ((0, xF86XK_AudioMute), spawn $ "amixer -q set Master toggle")

    -- Decrease volume
    , ((0, xF86XK_AudioLowerVolume), spawn $ "amixer -q set Master 5%-")

    -- Increase volume
    , ((0, xF86XK_AudioRaiseVolume), spawn $ "amixer -q set Master 5%+")

    -- Increase brightness
    , ((0, xF86XK_MonBrightnessUp),  spawn $ "xbacklight -inc 5")

    -- Decrease brightness
    , ((0, xF86XK_MonBrightnessDown), spawn $ "xbacklight -dec 2")

    , ((0, xF86XK_AudioPlay), spawn $ "playerctl play-pause && ~/.local/bin/player-notify")
    , ((0, xF86XK_AudioNext), spawn $ "playerctl next && ~/.local/bin/player-notify")
    , ((0, xF86XK_AudioPrev), spawn $ "playerctl previous && ~/.local/bin/player-notify")
    , ((0, xF86XK_AudioStop), spawn $ "playerctl stop")
    , ((0, xF86XK_HomePage), spawn "brave")
    , ((0, xF86XK_Search), spawn "dmsearch")
    , ((0, xF86XK_Mail), runOrRaise "thunderbird" (resource =? "thunderbird"))
    , ((0, xF86XK_Calculator), runOrRaise "qalculate-gtk" (resource =? "qalculate-gtk"))
    , ((0, xF86XK_Eject), spawn "toggleeject")

    , ((0, xK_Print), spawn "flameshot full -p ~/Pictures/Screenshots")
    , ((controlMask, xK_Print), spawn "flameshot full -c")
    , ((controlMask, xK_Print), spawn "flameshot full -c")
    , ((controlMask .|. shiftMask, xK_Print), spawn "flameshot gui")
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


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
                   ( smartBorders $ Full )

defaultLayouts = renamed [PrependWords "Default"] tiled ||| Mirror tiled ||| Full
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = mySpacing 5
               $ mkToggle (NOBORDERS ?? FULL ?? EOT)
               $ Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100
     tiled_ratio = 1/2

myLayout =  gaps [(U,38), (D,0), (R,0), (L,0)] defaultLayouts ||| fullscreenLayout

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
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , className =? "vlc"            --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , title =? "Picture in picture" --> doFloat
    , (className =? "firefox" <&&> (resource =? "Toolkit" <||> resource =? "Dialog"))  --> doFloat
    , resource  =? "kdesktop"       --> doIgnore
    , isFullscreen -->  doFullFloat]

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = do
               handleEventHook myBaseConfig <+> fullscreenEventHook <+> docksEventHook <+> ewmhDesktopsEventHook

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
myLogHook = return ()

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = do
  spawnOnce "~/.local/bin/autostart.sh"
  setWMName "XMonad"
------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
-- main = xmonad defaults

main :: IO ()
main = do
      dbus <- D.connectSession
      -- Request access to the DBus name
      D.requestName dbus (D.busName_ "org.xmonad.Log")
          [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]

      xmonad $ fullscreenSupport $ docks $ ewmh defaults
      --xmonad $ewmh defaults $ docks

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults = def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      --bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = manageSpawn <+> manageDocks <+> myManageHook <+> manageHook myBaseConfig,
        handleEventHook    = myEventHook,
        logHook            = myLogHook,
        startupHook        = myStartupHook >> addEWMHFullscreen
    }
