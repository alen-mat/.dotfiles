module My.Themes.Monnet where

import XMonad
import Data.Word
import XMonad.Layout.ShowWName
{--
Auto generated color from pywal
--}
colorScheme = "Monnet"

accent = "#C9150B"
colorBack = "#000000"
colorFore = "#f4a38d"

color0 = "#000000"
color1 = "#C9150B"
color2 = "#FB1B1A"
color3 = "#D33116"
color4 = "#B84222"
color5 = "#DE411F"
color6 = "#D04A25"
color7 = "#f4a38d"
color8 = "#aa7262"
color9 = "#C9150B"
color10 = "#FB1B1A"
color11 = "#D33116"
color12 = "#B84222"
color13 = "#DE411F"
color14 = "#D04A25"
color15 = "#f4a38d"

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


