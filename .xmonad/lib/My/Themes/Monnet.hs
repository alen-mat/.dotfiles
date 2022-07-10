module My.Themes.Monnet where

import XMonad
import Data.Word
import XMonad.Layout.ShowWName
{--
Auto generated color from pywal
--}
colorScheme = "Monnet"

accent = "#556A73"
colorBack = "#0f1213"
colorFore = "#ccdce4"

color0 = "#0f1213"
color1 = "#556A73"
color2 = "#9C7863"
color3 = "#5A7988"
color4 = "#6E8E9C"
color5 = "#8AA3AE"
color6 = "#A9C3D0"
color7 = "#ccdce4"
color8 = "#8e9a9f"
color9 = "#556A73"
color10 = "#9C7863"
color11 = "#5A7988"
color12 = "#6E8E9C"
color13 = "#8AA3AE"
color14 = "#A9C3D0"
color15 = "#ccdce4"

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


