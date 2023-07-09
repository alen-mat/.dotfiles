module My.Themes.Monnet where

import XMonad
import Data.Word
import XMonad.Layout.ShowWName
{--
Auto generated color from pywal
--}
colorScheme = "Monnet"

accent = "#524e51"
colorBack = "#1b1a1a"
colorFore = "#c6c5c5"

color0 = "#1b1a1a"
color1 = "#524e51"
color2 = "#724940"
color3 = "#6a5251"
color4 = "#876e62"
color5 = "#c39076"
color6 = "#eeba90"
color7 = "#c6c5c5"
color8 = "#545353"
color9 = "#524e51"
color10 = "#724940"
color11 = "#6a5251"
color12 = "#876e62"
color13 = "#c39076"
color14 = "#eeba90"
color15 = "#c6c5c5"

colorTrayer :: String
colorTrayer = "--tint 0x1d1f21"

myBorderWidth::Word32 
myBorderWidth   = 2

myFont :: String
myFont = "xft:SauceCodePro Nerd Font Mono:regular:size=9:antialias=true:hinting=true"

myShowWNameTheme :: SWNConfig
myShowWNameTheme = def
    { swn_font              = "xft:Ubuntu:bold:size=60"
    , swn_fade              = 1.0
    , swn_bgcolor           = "#1c1f24"
    , swn_color             = "#ffffff"
    }


