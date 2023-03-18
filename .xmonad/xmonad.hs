{--
	This xmonad monster is an amalgam of
	- Default xmonad config
	- https://gitlab.com/dwt1/dotfiles
	- https://github.com/Axarva/dotfiles-2.0
	- https://github.com/xintron/configs/blob/22a33b41587c180172392f80318883921c543053/.xmonad/lib/Config.hs#L199
	- https://github.com/xintron/xmonad-log
  - https://github.com/gvolpe/nix-config/blob/master/home/programs/xmonad/config.hs
  - https://github.com/psamim/dotfiles
  - https://github.com/yuttie
  - https://github.com/boogy
  - https://www.reddit.com/r/xmonad/comments/hheua0/detect_multiple_monitors/
  - https://github.com/jameslikeslinux/dotfiles/
  - https://github.com/zmanian/xmonad-config/blob/master/xmonad.hs
--}

import Control.Monad ( filterM, join, when, replicateM_,liftM2)

import Data.Foldable ( traverse_ )
import Data.Maybe (maybeToList)
import Data.List (elemIndex, isInfixOf, isSuffixOf, isPrefixOf )
import Data.Semigroup

import Graphics.X11.ExtraTypes.XF86

import System.Exit
import System.IO
import System.Process

import XMonad
import XMonad.Actions.CopyWindow
import XMonad.Actions.CycleWS
import XMonad.Actions.DynamicProjects ( Project(..), dynamicProjects, switchProjectPrompt)
import XMonad.Actions.DynamicWorkspaces ( removeWorkspace )
import XMonad.Actions.FloatKeys ( keysAbsResizeWindow, keysResizeWindow)
import XMonad.Actions.GridSelect
import XMonad.Actions.MouseResize
import XMonad.Actions.Navigation2D
import XMonad.Actions.RotSlaves (rotSlavesUp)
import XMonad.Actions.SpawnOn
import XMonad.Actions.TagWindows
import XMonad.Actions.WindowGo (runOrRaise)
import XMonad.Actions.WithAll (killAll)

import XMonad.Config.Azerty
import XMonad.Config.Desktop

import XMonad.Core

import My.Layouts
import My.Themes.Monnet

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.DynamicProperty
import XMonad.Hooks.EwmhDesktops ( ewmh, ewmhDesktopsEventHook)
import XMonad.Hooks.FadeInactive ( fadeInactiveLogHook )
import XMonad.Hooks.InsertPosition ( Focus(Newer), Position(Below, End), insertPosition)
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers ( (-?>), composeOne, doCenterFloat, doFullFloat, isDialog, isFullscreen, isInProperty)
import XMonad.Hooks.ScreenCorners
import XMonad.Hooks.ServerMode
import XMonad.Hooks.SetWMName
import XMonad.Hooks.UrgencyHook ( UrgencyHook(..), withUrgencyHook)

import XMonad.Layout.BinarySpacePartition
import XMonad.Layout.BoringWindows (boringWindows, focusUp, focusDown)
import XMonad.Layout.CenteredMaster (centerMaster)
import XMonad.Layout.Cross (simpleCross)
import XMonad.Layout.Fullscreen (fullscreenEventHook, fullscreenManageHook, fullscreenSupport, fullscreenFull)
import XMonad.Layout.Gaps ( Direction2D(D, L, R, U), gaps, setGaps, GapMessage(DecGap, ToggleGaps, IncGap) )
import XMonad.Layout.IndependentScreens

import XMonad.Layout.IndependentScreens
import XMonad.Layout.LayoutModifier (ModifiedLayout)
import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit)
import XMonad.Layout.Maximize (maximize, maximizeRestore)
import XMonad.Layout.Minimize(minimize)
import XMonad.Layout.MultiToggle (Toggle(..), mkToggle, single, EOT(EOT), (??))
import XMonad.Layout.MultiToggle.Instances
import qualified XMonad.Layout.NoBorders as NOB
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Renamed
import XMonad.Layout.ResizableTile
import XMonad.Layout.SimpleFloat
import XMonad.Layout.ShowWName
import XMonad.Layout.Spacing ( Spacing, spacingRaw, Border(Border), toggleSmartSpacing, toggleScreenSpacingEnabled, toggleWindowSpacingEnabled )
import XMonad.Layout.Spiral (spiral)
import XMonad.Layout.SubLayouts
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns
import XMonad.Layout.ToggleLayouts (toggleLayouts, ToggleLayout(Toggle))
import XMonad.Layout.WindowArranger (windowArrange, WindowArrangerMsg(..))
import XMonad.Layout.WindowNavigation

import XMonad.Prompt ( XPConfig(..), XPPosition(CenteredAt))

import XMonad.Util.EZConfig (additionalKeys, additionalMouseBindings)
import XMonad.Util.NamedScratchpad ( NamedScratchpad(..), customFloating, defaultFloating, namedScratchpadAction, namedScratchpadManageHook ,toggleDynamicNSP ,dynamicNSPAction)
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
import Graphics.X11.Xinerama as X11
import Graphics.X11.Xinerama (getScreenInfo)
import qualified XMonad.Layout.ToggleLayouts as T
import qualified XMonad.Layout.MultiToggle as MT
import qualified XMonad.StackSet as W
import qualified XMonad.Util.NamedWindows as W

import System.Environment

workSpacePerMonitor = False --getScreens > 1
--result <- readCreateProcess (shell "xrandr | grep " connected " | awk '{ print$1 }'|wc -l") myHaskellString
--workSpacePerMonitor = if (result > 1) then True else False

-- | Get an association list of ScreenId => output name
-- monitorIds = do
--  output <- T.pack <$> outputOf "xrandr --listactivemonitors 2>/dev/null | awk '{print $1 $4}'"
--  return $ mapMaybe parseMonitor . drop 1 $ T.lines output
--  where
--    parseMonitor :: T.Text -> Maybe (Int, T.Text)
--    parseMonitor text = do
--      let (idText, monitorText) = T.breakOn ":" text
--      monitor <- T.stripPrefix ":" monitorText
--      id <- readMaybe . T.unpack $ idText
--      return (id, monitor)

{--
Run X () actions by touching the edge of your screen with your mouse
https://wiki.archlinux.org/title/xmonad#Controlling_xmonad_with_external_scripts
--}
myHaskellString :: String
myHaskellString = "string"

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

myBaseConfig = desktopConfig
myTerminal      = "alacritty"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses =  True

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
---mod4Mask= super key
--mod1Mask= alt key
--controlMask= ctrl key
--shiftMask= shift key

altMask = mod1Mask
myModMask = mod4Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
webWs = "web"
ossWs = "oss"
devWs = "dev"
comWs = "com"
wrkWs = "wrk"
sysWs = "sys"
etcWs = "etc"
normalWorkspaces :: [WorkspaceId]
normalWorkspaces = ["1","2","3","4","5","6","7","8","9"]

dwmLikeWorkspaces = withScreens 2 normalWorkspaces

myWorkspaces = if (workSpacePerMonitor) then dwmLikeWorkspaces else normalWorkspaces

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor :: String
myNormalBorderColor   = colorBack

myFocusedBorderColor :: String
myFocusedBorderColor  = color14

toggleFullScreen = do
      sendMessage( MT.Toggle FULL)
      >> sendMessage ToggleStruts
      >> toggleScreenSpacingEnabled
      >> toggleWindowSpacingEnabled
      >> sendMessage ToggleGaps
      >> toggleSmartSpacing



------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
-- https://wiki.linuxquestions.org/wiki/XF86_keyboard_symbols
--
kill8 ss | Just w <- W.peek ss = W.insertUp w $ W.delete w ss
  | otherwise = ss
--

showKeybindings :: [((KeyMask, KeySym), NamedAction)] -> NamedAction
showKeybindings x = addName "Show Keybindings" . io $
  E.bracket (spawnPipe $ getAppCommand xmonKeYad) hClose (\h -> hPutStr h (unlines $ showKm x))

myKeys conf@XConfig {XMonad.modMask = modm} =
  keySet "Launchers"
    [ key "Terminal"                 (modm .|. shiftMask, xK_Return        ) $ spawn (XMonad.terminal conf)
    , key "Apps (Rofi)"              (modm              , xK_l             ) $ spawn $ "~/.local/bin/rofi_helper -a"
    , key "Bluetooth Manager (Rofi)" (modm              , xK_bracketleft   ) $ spawn $ "~/.local/bin/rofi_helper -bm"
    , key "Network Manager (Rofi)"   (modm              , xK_bracketright  ) $ spawn $ "~/.local/bin/rofi_helper -nm"
    , key "Power Menu (Rofi)"        (modm              , xK_semicolon     ) $ spawn $ "~/.local/bin/rofi_helper -p"
    , key "ClipBoard (Rofi)"         (modm              , xK_v             ) $ spawn $ "~/.local/bin/rofi_helper -gc"
    , key "Switcher (Rofi)"          (modm              , xK_Tab           ) $ spawn $ "~/.local/bin/rofi_helper -ss"
    , key "Emoji Picker (Rofi)"      (modm .|. altMask  , xK_period        ) $ spawn $ "~/.local/bin/rofi_helper -ep"
    , key "Buku BookMarks (Rofi)"    (modm .|. altMask  , xK_b             ) $ spawn $ "~/.local/bin/rofi_helper -bb"
    , key "Bitwarden (Rofi)"         (modm .|. altMask  , xK_slash         ) $ spawn $ "~/.local/bin/rofi_helper -bw"
    , key "Playerctl (Rofi)"         (modm              , xF86XK_AudioPlay ) $ spawn $ "~/.local/bin/rofi_helper -pctl"
    , key "Utils (Rofi)"             (modm              , xK_slash         ) $ spawn $ "~/.local/bin/rofi_helper -u"
    , key "Lock screen"              (modm .|. altMask  , xK_l             ) $ spawn $ "~/.local/bin/lock-x-session"
    ] ^++^
  keySet "Audio"
    [ key "Mic Mute"      (0, xF86XK_AudioMicMute           ) $ spawn $ "~/.scripts/notify/audio --mic-toggle"
    , key "Mute"          (0, xF86XK_AudioMute              ) $ spawn $ "~/.scripts/notify/audio --spkr-toggle"
    , key "Lower volume"  (0, xF86XK_AudioLowerVolume       ) $ spawn $ "~/.scripts/notify/audio --spkr-d"
    , key "Raise volume"  (0, xF86XK_AudioRaiseVolume       ) $ spawn $ "~/.scripts/notify/audio --spkr-i"
    , key "Play / Pause"  (0, xF86XK_AudioPlay              ) $ spawn $ "~/.scripts/notify/media --pp"
    , key "Stop"          (0, xF86XK_AudioStop              ) $ spawn $ "~/.scripts/notify/media --stop"
    , key "Previous"      (0, xF86XK_AudioPrev              ) $ spawn $ "~/.scripts/notify/media --prev"
    , key "Next"          (0, xF86XK_AudioNext              ) $ spawn $ "~/.scripts/notify/media --next"
    ] ^++^
  keySet "Brigtness"
    [ key "Increase brigtness"  (0, xF86XK_MonBrightnessUp  ) $  spawn $ "~/.scripts/notify/brightness -i"
    , key "Decrease brightness" (0, xF86XK_MonBrightnessDown) $  spawn $ "~/.scripts/notify/brightness -d"
    ] ^++^
  keySet "Fn Keys"
    [ key "Homepage"   (0, xF86XK_HomePage  ) $ spawn "brave"
    , key "Search"     (0, xF86XK_Search    ) $ spawn "dmsearch"
    , key "Mail"       (0, xF86XK_Mail      ) $ runOrRaise "thunderbird" (resource =? "thunderbird")
    , key "Calculator" (0, xF86XK_Calculator) $ runOrRaise "qalculate-gtk" (resource =? "qalculate-gtk")
    , key "Eject"      (0, xF86XK_Eject     ) $ spawn "toggleeject"
    , key "Project"    (modm, xK_p          ) $ runOrRaise "arandr" (className =? "Arandr") 
    ] ^++^
  keySet "Scratchpads"
    [ key "Audacious"       (modm .|. controlMask,  xK_a    ) $ runScratchpadApp audacious
    , key "bottom"          (modm .|. controlMask,  xK_y    ) $ runScratchpadApp btm
    , key "Files"           (modm .|. controlMask,  xK_f    ) $ runScratchpadApp nautilus
    , key "Screen recorder" (modm .|. controlMask,  xK_r    ) $ runScratchpadApp scr
    , key "Spotify"         (modm .|. controlMask,  xK_s    ) $ runScratchpadApp spotify
    , key "Alacritty"       (modm .|. controlMask,  xK_t    ) $ runScratchpadApp kterm
    , key "Emacs"           (modm .|. controlMask,  xK_e    ) $ runScratchpadApp emScratch

    , key "Dynamic scratchpad 1"  (modm .|. controlMask .|. shiftMask,  xK_e ) $ withFocused $ toggleDynamicNSP "dyn1"
    , key "Dynamic scratchpad 2"  (modm .|. controlMask .|. shiftMask,  xK_e ) $ withFocused $ toggleDynamicNSP "dyn2"
    , key "Toggle SP 1"           (modm .|. controlMask,  xK_e    ) $  dynamicNSPAction "dyn1"
    , key "Toggle SP 2"           (modm .|. controlMask,  xK_e    ) $ dynamicNSPAction "dyn2"
    ] ^++^
  keySet "System"
    [ key "Toggle status bar gap"          (modm                      , xK_b )     toggleStruts
    , key "Logout (quit XMonad)"           (modm .|. shiftMask        , xK_q )     $ io exitSuccess
    , key "Restart XMonad"                 (modm                      , xK_q )     $ spawn "xmonad --restart"
    , key "Capture entire screen to file"  (modm                      , xK_Print)  $ spawn "~/.local/bin/maim_helper screen"
    , key "Capture entire screen to clip"  (controlMask               , xK_Print)  $ spawn "~/.local/bin/maim_helper screen clip"
    , key "Capture partial screen to clip" (controlMask .|. shiftMask , xK_Print)  $ spawn "~/.local/bin/maim_helper selection clip"
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
    , key "Shrink master"   (modm .|. shiftMask, xK_h        ) $ sendMessage Shrink
    , key "Expand master"   (modm .|. shiftMask, xK_l        ) $ sendMessage Expand
    , key "Switch to tile"  (modm              , xK_t        ) $ withFocused (windows . W.sink)
    , key "Rotate slaves"   (modm .|. shiftMask, xK_Tab      ) rotSlavesUp
    , key "Decrease size"   (modm              , xK_d        ) $ withFocused (keysResizeWindow (-10,-10) (1,1))
    , key "Increase size"   (modm              , xK_s        ) $ withFocused (keysResizeWindow (10,10) (1,1))
    , key "Decr  abs size"  (modm .|. shiftMask, xK_d        ) $ withFocused (keysAbsResizeWindow (-10,-10) (1024,752))
    , key "Incr  abs size"  (modm .|. shiftMask, xK_s        ) $ withFocused (keysAbsResizeWindow (10,10) (1024,752))
    , key "Invert Window"   (modm              , xK_i        ) $ spawn "~/.scripts/invert-window"
    , key "float everywhere"(modm              , xK_a        ) $ sequence_ $ [windows $ copy i | i <- XMonad.workspaces conf]    -- Pin to all workspaces
    , key "float everywhere"(modm .|. shiftMask, xK_a        ) $ windows $ kill8      -- remove from all but current
    ] ^++^
  keySet "Tag Windows"
    [ key "" (modm,                    xK_g ) $ tagPrompt myXPConfig (\ s -> withFocused (addTag s))
    , key "" (modm .|. controlMask,    xK_g ) $ tagDelPrompt myXPConfig
    , key "" (modm .|. shiftMask,      xK_g ) $ tagPrompt myXPConfig (\s -> withTaggedGlobal s float)
    , key "" (altMask,                 xK_g ) $ tagPrompt myXPConfig (\s -> withTaggedP s (W.shiftWin "2"))
    , key "" (altMask .|. shiftMask,   xK_g ) $ tagPrompt myXPConfig (\s -> withTaggedGlobalP s shiftHere)
    , key "" (altMask .|. controlMask, xK_g ) $ tagPrompt myXPConfig (\s -> focusUpTaggedGlobal s)
    ] ^++^
  keySet "Misc"
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
    switchWsById = if (workSpacePerMonitor) then
      [ key (action m <> show i) (m .|. modm, k) (windows $ onCurrentScreen f i)
          | (i, k) <- zip (workspaces' conf) [xK_1 .. xK_9]
          , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    else
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
  findWorkspace filterOutNSP dir anyWS 1 >>= windows . W.view

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

    , ((modm .|. shiftMask, button3), (const $ spawn $ "~/.scripts/color-pick"))

    -- , ((modm, button3), (\w -> focus w >> Flex.mouseResizeWindow w))

    -- , ((mySup, 1), (\w -> focus w >> windows W.swapUp))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    , ((modm, button4),               (\_ -> windows W.focusUp))
    , ((modm, button5),               (\_ -> windows W.focusDown))
    , ((modm .|. shiftMask, button4), (\_ -> windows W.swapUp))
    , ((modm .|. shiftMask, button5), (\_ -> windows W.swapDown))
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
    sa  <- getAtom "_NET_WM_STATE_ABOVE"
    sky <- getAtom "_NET_WM_STATE_STICKY"
    mapM_ addNETSupported [wms, wfs, sa, sky]


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

fullscreenLayout = renamed [PrependWords "fullscreen"]
                   ( NOB.noBorders $ Full )

myLayout = gaps [(U,5), (D,5), (R,5), (L,5)] $ NOB.smartBorders ( defaultLayouts ) 

-- myLayoutHook = showWName' myShowWNameTheme $ myLayout
myLayoutHook = NOB.lessBorders NOB.Never $ avoidStruts $ mouseResize $ windowArrange $ onWorkspace "6" imLayout $T.toggleLayouts floats
               $ screenCornerLayoutHook $ mkToggle (NBFULL ?? NOBORDERS ?? EOT) defaultLayouts


-- Set default layout per workSpace
-- myLayout = onWorkspaces ["4"] simpleFloat $ smartBorders(defaultLayouts)

------------------------------------------------------------------------
-- Window rules:
windowRules = composeAll . concat $
    [ 
      [className =? c --> doCenterFloat | c <- myCFloats]
    , [title =? t --> doCenterFloat | t <- myTFloats]
    , [resource =? r --> doFloat | r <- myRFloats]
    , [resource =? i --> doIgnore | i <- myIgnores]
    , [ myIsPrefixOf "zoom"            className <&&> myIsPrefixOf "zoom"            title --> doShiftAndGo "6"]
    , [ myIsPrefixOf "Microsoft Teams" className <&&> myIsPrefixOf "Microsoft Teams" title --> doShiftAndGo "6"]

    -- move windows to specific workspaces
    , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "1" | x <- my1Shifts ]
    , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "2" | x <- my2Shifts ]
    , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "3" | x <- my3Shifts ]
    , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "4" | x <- my4Shifts ]
    , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "5" | x <- my5Shifts ]
    , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "6" | x <- my6Shifts ]
    , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "7" | x <- my7Shifts ]
    , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "8" | x <- my8Shifts ]
    , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "9" | x <- my9Shifts ]
    ]
    where
                doShiftAndGo = doF . liftM2 (.) W.greedyView W.shift
		myCFloats = ["alacritty-float", "MPlayer", "mpv","alacritty-cava"
					,"Gimp", "feh", "Viewnior", "Gpicview"
					,"Kvantum Manager", "qt5ct", "VirtualBox Manager", "qemu", "Qemu-system-x86_64"
					,"Lxappearance", "Nitrogen", "Arandr", "Xfce4-power-manager-settings", "Nm-connection-editor","scrcpy"]
		myTFloats = ["Downloads", "Save As..."]
		myRFloats = []
		myIgnores = ["desktop_window"]
                my1Shifts = []
                my2Shifts = []
                my3Shifts = []
                my4Shifts = []
                my5Shifts = []
                my6Shifts = ["zoom", "Zoom Meeting", "Zoom - Licensed Account","Skype"]
                my7Shifts = []
                my8Shifts = []
                my9Shifts = []

myIsInfixOf str = do
    fmap $ isInfixOf str

myIsPrefixOf str = do
    fmap $ isPrefixOf str
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
doLower :: ManageHook
doLower = ask >>= \w -> liftX $ withDisplay $ \dpy -> io (lowerWindow dpy w) >> mempty

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
spotify   = ClassApp "Spotify"              "spotify"
vlc       = ClassApp "Vlc"                  "vlc"
xmonKeYad = TitleApp "xmonad-keys-yad"      "yad --text-info --text 'XMonad' --show-uri --width=300 --height=200 --center --wrap --window-icon='text-editor' --no-buttons --undecorated --title='xmonad-keys-yad' # --back=COLOR --fore=COLOR "

kterm     = ClassApp "alacritty-scratch"    "alacritty -o alacritty -o 'window.dimensions.lines=25' -o 'window.dimensions.columns=82' --class 'alacritty-scratch'"
emScratch = TitleApp "_emacs_scratchpad_"   "emacsclient --frame-parameters '((name . \"_emacs_scratchpad_\"))' -nc"





myManageHook =  windowRules <+> manageApps <+> manageSpawn <+> manageScratchpads
 where
  isBrowserDialog     = isDialog <&&> className =? "Brave-browser"
  isFileChooserDialog = isRole =? "GtkFileChooserDialog"
  isPopup             = isRole =? "pop-up"

  isSplash            = isInProperty "_NET_WM_WINDOW_TYPE" "_NET_WM_WINDOW_TYPE_SPLASH"
  isNotification      = isInProperty "_NET_WM_WINDOW_TYPE" "_NET_WM_WINDOW_TYPE_NOTIFICATION"
  isDia               = isInProperty "_NET_WM_WINDOW_TYPE" "_NET_WM_WINDOW_TYPE_DIALOG"
  isMenu              = isInProperty "_NET_WM_WINDOW_TYPE" "_NET_WM_WINDOW_TYPE_MENU"
  isKDE               = isInProperty "_NET_WM_WINDOW_TYPE" "_KDE_NET_WM_WINDOW_TYPE_OVERRIDE"
  isRole              = stringProperty "WM_WINDOW_ROLE"
  isDesktop           = isInProperty "_NET_WM_WINDOW_TYPE" "_NET_WM_WINDOW_TYPE_DESKTOP"
  isDock              = isInProperty "_NET_WM_WINDOW_TYPE" "_NET_WM_WINDOW_TYPE_DOCK"
  isOSD               = isInProperty "_NET_WM_WINDOW_TYPE" "_KDE_NET_WM_WINDOW_TYPE_ON_SCREEN_DISPLAY"
  isXmonadTagF        = isInProperty "_XMONAD_TAGS" "float"

  tileBelow         = insertPosition Below Newer
  doCalendarFloat   = customFloating (W.RationalRect (11 / 15) (1 / 48) (1 / 4) (1 / 4))
  doYadDiagFloat    = customFloating (W.RationalRect (1 / 6)   (1 / 6)  (2 / 3) (2 / 3))
  manageScratchpads = namedScratchpadManageHook scratchpads

  sendToBottom :: Window -> X ()
  sendToBottom window = withDisplay $ \display ->
      io $ lowerWindow display window

  raiseWindow' :: Window -> X ()
  raiseWindow' window = withDisplay $ \display ->
      io $ raiseWindow display window

  allWindowsByType :: Query Bool -> X [Window]
  allWindowsByType query = withDisplay $ \display -> do
      (_, _, windows) <- asks theRoot >>= io . queryTree display
      filterM (runQuery query) windows

  sendToJustAboveDesktop :: Window -> X ()
  sendToJustAboveDesktop window = do
      sendToBottom window
      allWindowsByType isDesktop >>= mapM_ sendToBottom

  doWindowAction :: (Window -> X ()) -> ManageHook
  doWindowAction action = ask >>= liftX . action >> idHook

  raiseAllNotifications :: X ()
  raiseAllNotifications = allWindowsByType isNotification >>= mapM_ raiseWindow'

  raiseAllNotificationsHook :: ManageHook
  raiseAllNotificationsHook = liftX raiseAllNotifications >> idHook


  anyOf :: [Query Bool] -> Query Bool
  anyOf = foldl (<||>) (pure False)
  match :: [App] -> Query Bool
  match = anyOf . fmap isInstance
  manageApps = composeOne
    [ isInstance calendar                      -?> doCalendarFloat
    , isInstance xmonKeYad                     -?> doYadDiagFloat
    , match [ gimp, office ]                   -?> doFloat
    , match [ audacious
            , eog
            , nautilus
            , pavuctrl
            , scr
            ]                                  -?> doCenterFloat
    , match [ btm, evince, spotify, vlc]       -?> doFullFloat
    , resource =? "desktop_window"             -?> doIgnore
    , resource =? "kdesktop"                   -?> doIgnore
    , anyOf [ isBrowserDialog
            , isFileChooserDialog
            , isDialog
            , isPopup
            , isSplash
            , isNotification
            , isDia
            , isMenu
            , isKDE
            , isXmonadTagF
            ]                                  -?> doCenterFloat
    , title =? "Picture in picture"            -?> doFloat
	, className =? "Yad"                       -?> doFloat
	, className =? "Xboard"                    -?> doFloat
	, className =? "Blueman-manager"           -?> doCenterFloat
    , (className =? "firefox" <&&> (resource =? "Toolkit" <||> resource =? "Dialog"))  -?> doFloat
    , isFullscreen                             -?> doFullFloat
    , pure True                                -?> tileBelow
    , className =? "Wfica" <&&> title =? "WorkSpace Enterprise_SG2_PROD_01 "                     -?> doShift "9"
    , pure True                     -?> insertPosition Below Newer
    , isDesktop                     -?> doWindowAction sendToBottom
    , isDock                        -?> doWindowAction sendToJustAboveDesktop
    , isOSD                         -?> doCenterFloat
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

scratchpads = scratchpadApp <$> [ audacious, btm, nautilus, scr, spotify, kterm, emScratch]


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
  , bgColor = colorBack
  , fgColor = colorFore
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

myPolybarLogHook dbus = fadeLogHook <+> dynamicLogWithPP (polybarHook dbus)


------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myDynamicEventHook :: Event -> X All
myDynamicEventHook = dynamicPropertyChange "WM_NAME" (title =? "Spotify" --> floating)
        where floating = customFloating $ W.RationalRect (1/6) (1/12) (1/6) (1/4)


myEventHook = do
               handleEventHook myBaseConfig <+> fullscreenEventHook <+> screenCornerEventHook <+> myDynamicEventHook <+> serverModeEventHook 
------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
-- myLogHook = return ()
fadeLogHook :: X ()
fadeLogHook = fadeInactiveLogHook fadeAmount
    where fadeAmount = 0.9

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = do
  addScreenCorners [ (SCLowerLeft,  prevWS')
                   , (SCLowerRight, nextWS')
                   , (SCUpperLeft, spawnSelected' myAppGrid)
                   , (SCUpperRight, goToSelected $ mygridConfig myColorizer)
                 ]
  spawnOnce "~/.xmonad/autostart"
  spawnOnce "~/.local/bin/autostart.sh"

  setWMName "LG3D"

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
-- main = xmonad defaults

main :: IO ()
main = mkDbusClient >>= main'

main' :: D.Client -> IO ()
main' dbus = xmonad . ewmh . docks . dynProjects . keybindings . urgencyHook$ fullscreenSupport $ def {
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
  manageHook         = fullscreenManageHook <+> manageSpawn <+> manageDocks <+>  myManageHook <+> manageHook myBaseConfig,
  handleEventHook    = myEventHook,
  logHook            = myPolybarLogHook dbus,
  startupHook        = myStartupHook <+> addEWMHFullscreen
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
