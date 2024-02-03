#!/bin/sh
declare -i i=$(cat ~/.config/hypr/scripts/wallpaper) 
swaylock -i ~/Media/Pictures/walls/active/$i*
