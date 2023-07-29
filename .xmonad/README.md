## Not the best or the optimal but always a WIP
This xmonad monster is an amalgam of all the following config
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
  - https://github.com/elkowar/dots-of-war/blob/master/xmonad/.xmonad/lib/Config.hs
  - https://github.com/NeshHari/XMonad/tree/oldmain

### if xmonad breaks after update , even with all dependencies met
  1. sudo pacman -Rdd $(pacman -Qsq haskell-)  # remove all haskell dependencies
  2. reinstall xmonad,xmonad-contrib,xmonad-utils,haskell-dbus
  3. install xmonad-log from AUR
