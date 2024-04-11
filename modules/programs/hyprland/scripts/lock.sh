#!/bin/sh
declare -i i=$(cat ~/.config/hypr/scripts/wallpaper) 
swaylock -i ~/.config/hypr/scripts/wallpapers/$i*
