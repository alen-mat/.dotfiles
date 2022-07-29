#!/usr/bin/env bash
source ~/.config/.restore-setup/pacman_hook-conf.sh
source ~/.config/.restore-setup/update-sys-conf-files.sh 

sudo pacman -S --needed $(comm -12 <(pacman -Slq | sort) <(sort ~/.config/.restore-setup/pacman_packages))

