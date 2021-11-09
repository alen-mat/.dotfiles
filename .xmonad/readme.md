if xmonad breaks after update , even with all dependencies met
1. sudo pacman -Rdd $(pacman -Qsq haskell-)  # remove all haskell dependencies
2. reinstall xmonad,xmonad-contrib,xmonad-utils,haskell-dbus
3. install xmonad-log from AUR
