#!/bin/sh


declare -i i=$(cat ~/.config/hypr/scripts/wallpaper)
swww img ~/Media/Pictures/walls/active/$i* -t random
