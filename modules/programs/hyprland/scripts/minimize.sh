#!/bin/bash

active_window=$(hyprctl -j activewindow | jq -r '.workspace.name')
active_workspace=$(hyprctl -j activeworkspace | jq -r '.name')

if [[ "$active_window" == "special:min" ]]; then
    hyprctl dispatch movetoworkspacesilent "$active_workspace"
else
    hyprctl dispatch movetoworkspacesilent "$1"
fi
