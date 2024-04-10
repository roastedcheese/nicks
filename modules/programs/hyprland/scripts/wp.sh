#!/bin/sh


declare -i i=$(cat ~/.config/hypr/scripts/wallpaper)
swww img ~/.config/hypr/scripts/walls/$i* -t random
