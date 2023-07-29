module My.Decorations where

import My.Theme
import My.CS.TomorrowNight
import XMonad 
import XMonad.Actions.EasyMotion
import XMonad.Layout.ShowWName
import XMonad.Layout.Tabbed
import XMonad.Prompt


myXPConfig :: XPConfig
myXPConfig = def
  { bgHLight = color4
  , bgColor = colorBack
  , fgColor = colorFore
  , fgHLight = color2
  , borderColor= color13
  , font     = myFont
  , height   = 50
  , position = CenteredAt 0.5 0.5
  }

myPromptConfig :: XPConfig
myPromptConfig =
  def
    { bgColor = colorBack,
      fgColor = colorFore,
      bgHLight = color8,
      fgHLight = color4,
      historySize = 0,
      position = Top,
      borderColor = color8,
      promptBorderWidth = 0,
      defaultText = "",
      alwaysHighlight = True,
      height = 55,
      font = myFont,
      autoComplete = Nothing,
      showCompletionOnTab = False
    }

myShowWNameConfig :: SWNConfig
myShowWNameConfig =
  def
    { swn_font = myFont,
      swn_color = color8,
      swn_bgcolor = colorBack,
      swn_fade = 0.8
    }

myTabConfig :: Theme
myTabConfig =
  def
    { activeColor = color1,
      inactiveColor = color2,
      urgentColor = color3,
      activeBorderColor = color4,
      inactiveBorderColor = color5,
      urgentBorderColor = color6,
      activeTextColor = color7,
      inactiveTextColor = color8,
      urgentTextColor = color9,
      fontName = myFont
    }

emConf :: EasyMotionConfig
emConf =
  def
    { txtCol = colorFore,
      bgCol = colorBack,
      borderCol = color7,
      cancelKey = xK_Escape,
      emFont = myFont,
      overlayF = textSize,
      borderPx = 30
    }
