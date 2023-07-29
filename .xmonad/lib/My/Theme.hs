module My.Theme where

import My.CS.TomorrowNight
import XMonad

myBorderWidth :: XMonad.Dimension
myBorderWidth = 2

myNormalBorderColor :: String
myNormalBorderColor = colorBack 

myFocusedBorderColor :: String
myFocusedBorderColor = color4 

myFont :: String
myFont = "xft:SauceCodePro Nerd Font Mono:regular:size=9:antialias=true:hinting=true"
