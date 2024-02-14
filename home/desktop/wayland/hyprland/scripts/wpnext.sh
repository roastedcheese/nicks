#!/bin/sh

declare -i max=$1
declare -i i=$(cat ~/.config/hypr/scripts/wallpaper)
i=$((i + 1))

if [ $i = $((max + 1)) ]; then
    i=1
fi

swww img ~/Media/Pictures/walls/active/$i* -t random
echo $i > ~/.config/hypr/scripts/wallpaper
