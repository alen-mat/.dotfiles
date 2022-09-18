module My.Layouts(defaultLayouts, floats, imLayout)  where
import My.Themes.Monnet

import Data.Ratio ((%))
import Data.Semigroup

import XMonad.Layout
import XMonad.Layout.MultiToggle.Instances (StdTransformers(MIRROR))
import XMonad.Layout.Renamed

import XMonad.Layout.Accordion
import XMonad.Layout.Column
import XMonad.Layout.Combo
import XMonad.Layout.ComboP
import XMonad.Layout.GridVariants (Grid(Grid))
import XMonad.Layout.IM
import XMonad.Layout.Spiral
import XMonad.Layout.Reflect
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns
import XMonad.Layout.TwoPane
import XMonad.Layout.Simplest
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Magnifier

import XMonad.Layout.SubLayouts

import XMonad.Layout.LimitWindows (limitWindows)

import XMonad.Layout.MultiToggle (mkToggle, single)

import XMonad.Layout.LayoutModifier (ModifiedLayout)
import XMonad.Layout.Spacing ( Spacing, spacingRaw, Border(Border))
import XMonad.Layout.WindowNavigation
import XMonad.Layout.NoBorders

myTabTheme = def { fontName            = myFont
                 , activeColor         = color14
                 , inactiveColor       = color7
                 , activeBorderColor   = color14
                 , inactiveBorderColor = colorBack
                 , activeTextColor     = colorBack
                 , inactiveTextColor   = color15
                 }

mySpacing :: Integer -> l a -> ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border 0 i 0 i) True (Border i 0 i 0) True

--mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
--mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

mySpacing' :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing' i = spacingRaw True (Border i i i i) True (Border i i i i) True

tall     = renamed [Replace "tall"]
           $ smartBorders
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 12
           $ mySpacing 5
           $ ResizableTall 1 (3/100) (1/2) []
_magnify  = renamed [Replace "magnify"]
           $ smartBorders
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ magnifier
           $ limitWindows 12
           $ mySpacing 5
           $ ResizableTall 1 (3/100) (1/2) []
monocle  = renamed [Replace "▆▆▆"]
           $ smartBorders
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 20 Full
floats   = renamed [Replace "floats"]
           $ smartBorders
           $ limitWindows 20 simplestFloat
grid     = renamed [Replace "▦"]
           $ smartBorders
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 12
           $ mySpacing 5
           $ mkToggle (single MIRROR)
           $ Grid (16/10)
spirals  = renamed [Replace "spirals"]
           $ smartBorders
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ mySpacing' 5
           $ spiral (6/7)
threeCol = renamed [Replace "｜｜｜"]
           $ smartBorders
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 7
           $ ThreeCol 1 (3/100) (1/2)
threeRow = renamed [Replace "☰"]
           $ smartBorders
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 7
           -- Mirror takes a layout and rotates it by 90 degrees.
           -- So we are applying Mirror to the ThreeCol layout.
           $ Mirror
           $ ThreeCol 1 (3/100) (1/2)
tabs     = renamed [Replace "tabs"]
           -- I cannot add spacing to this layout because it will
           -- add spacing between window and tabs which looks bad.
           $ tabbed shrinkText myTabTheme
tallAccordion  = renamed [Replace "tallAccordion"]
           $ Accordion
wideAccordion  = renamed [Replace "wideAccordion"]
           $ Mirror Accordion
------------------------------------------------------------------------
rosterLayout    = Column 1
tabbedLayout    = noBorders (tabbed shrinkText myTabTheme ) --{ fontName = myTabFont })
imLayout1        = withIM (2%8) (ClassName "KotatogramDesktop") $ chatLayout where
    chatLayout      = combineTwoP (TwoPane 0.5 0.2) rosterLayout tabbedLayout rosters
    rosters         = (pidginRoster `Or` skypeRoster `Or` odeskRoster `Or` kotogram)
    pidginRoster    = (ClassName "Pidgin")          `And` (Title "Buddy List")
    skypeRoster     = (ClassName "Skype")           `And` (Not (Title "Options")) `And` (Not (Role "Chats")) `And` (Not (Role "CallWindowForm"))
    odeskRoster     = (ClassName "Odeskteam.bin")   `And` (Title "oDesk Team Room")
    kotogram        = (ClassName "kotatogram-desktop")

imLayout = withIM (1%7) pidginRoster 
    $ reflectHoriz 
    $ withIM (2%8) skypeRoster 
    $ withIM (2%8) kotogram
    (grid ||| Full ||| tabs)
    where
        pidginRoster = And (ClassName "Pidgin") (Role "buddy_list")
        --This doesn't quite work with the latest version of Skype,
        --so a new conversation/call may snap to the right and push
        --the buddy list into the center tiled area
        kotogram= (ClassName "KotatogramDesktop")
        skypeRoster = (ClassName "Skype") `And` (Not (Title "Options")) `And` (Not (Role "ConversationsWindow")) `And` (Not (Role "CallWindow"))
-----------------------------------------------------

defaultLayouts =  withBorder myBorderWidth $ tall
                                 ||| _magnify
                                 ||| noBorders monocle
                                 ||| floats
                                 ||| noBorders tabs
                                 ||| grid
                                 ||| spirals
                                 ||| threeCol
                                 ||| threeRow
                                 ||| tallAccordion
                                 ||| wideAccordion

