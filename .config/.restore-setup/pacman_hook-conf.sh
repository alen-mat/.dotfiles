#!/usr/bin/env bash
addPacmanHooks(){
####Pacman Hooks
  if [ ! -f "/etc/pacman.d/hooks/haskell_post_update.hook" ];then
cat << EOF > /etc/pacman.d/hooks/haskell_post_update.hook
[Trigger]
Operation = Upgrade
Type = Package
Target = haskell*

[Action]
Description = Recompiling Xmonad now because of Haskell updates ...
When = PostTransaction
Depends = xmonad
Exec = /bin/sh -c "runuser -l $( who | cut -d ' ' -f1 | uniq) -c 'xmonad --recompile'"
EOF
  echo "[*] Added Haskell Post Update Hook"
else
  echo "[-] Hook is already available"
fi

  if [ ! -f "/etc/pacman.d/hooks/xmonad_post_update.hook" ];then
cat << EOF >/etc/pacman.d/hooks/xmonad_post_update.hook
[Trigger]
Operation = Upgrade
Type = Package
Target = xmonad*

[Action]
Description = Recompiling Xmonad now because of Xmonad updates...
When = PostTransaction
Depends = xmonad
Exec = /bin/sh -c "runuser -l $( who | cut -d ' ' -f1 | uniq) -c 'xmonad --recompile'"
EOF

  echo "[*] Added Xmonad Post Update Hook"
else
  echo "[-] Hook is already available"
fi
}

addPacmanHooks
