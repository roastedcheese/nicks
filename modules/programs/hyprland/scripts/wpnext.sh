#!/bin/sh

declare -i max=$1
declare -i i=$(cat ~/.config/hypr/scripts/wallpaper)
i=$((i + 1))

if [ $i = $((max + 1)) ]; then
    i=1
fi

swww img ~/.config/hypr/scripts/wallpapers/$i* -t random
echo $i > ~/.config/hypr/scripts/wallpaper
