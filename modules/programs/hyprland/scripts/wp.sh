#!/bin/sh


declare -i i=$(cat ~/.config/hypr/scripts/wallpaper)
awww img ~/.config/hypr/scripts/wallpapers/$i* -t random
