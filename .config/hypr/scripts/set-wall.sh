#!/bin/bash
WALL_DIR=~/Pictures/wallpapers
wallpaper=$( find $WALL_DIR -type f \( -name '*.jpg' -o -name '*.png' \) -print0 | shuf -n1 -z )

matugen image "$wallpaper"

swww img  "$wallpaper"  --transition-step 100 --transition-fps  120 --transition-type  grow --transition-duration 1 --transition-angle 27

