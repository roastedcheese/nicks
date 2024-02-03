{
  wayland.windowManager.hyprland.settings = {
    "$mainMod" = "SUPER";

    bind = [
      # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
      "$mainMod, Q, exec, foot"
      "$mainMod, C, killactive,"
      "$mainMod SHIFT, Q, exit,"
      "$mainMod, V, togglefloating,"
      "$mainMod, R, exec, killall wofi || wofi --show drun"
      "$mainMod, P, pseudo,"
      "$mainMod, Space, togglesplit,"
      "$mainMod, F, fullscreen"
      "$mainMod SHIFT, F, fullscreen, 1"

      # Move focus with mainMod + arrow keys
      "$mainMod, h, movefocus, l"
      "$mainMod, l, movefocus, r"
      "$mainMod, k, movefocus, u"
      "$mainMod, j, movefocus, d"

      # Switch workspaces with mainMod + [0-9]
      "$mainMod, 1, workspace, 1"
      "$mainMod, 2, workspace, 2"
      "$mainMod, 3, workspace, 3"
      "$mainMod, 4, workspace, 4"
      "$mainMod, 5, workspace, 5"
      "$mainMod, 6, workspace, 6"
      "$mainMod, 7, workspace, 7"
      "$mainMod, 8, workspace, 8"
      "$mainMod, 9, workspace, 9"
      "$mainMod, 0, workspace, 10"

      # Move active window to a workspace with mainMod + SHIFT + [0-9]
      "$mainMod SHIFT, 1, movetoworkspace, 1"
      "$mainMod SHIFT, 2, movetoworkspace, 2"
      "$mainMod SHIFT, 3, movetoworkspace, 3"
      "$mainMod SHIFT, 4, movetoworkspace, 4"
      "$mainMod SHIFT, 5, movetoworkspace, 5"
      "$mainMod SHIFT, 6, movetoworkspace, 6"
      "$mainMod SHIFT, 7, movetoworkspace, 7"
      "$mainMod SHIFT, 8, movetoworkspace, 8"
      "$mainMod SHIFT, 9, movetoworkspace, 9"
      "$mainMod SHIFT, 0, movetoworkspace, 10"

      # Scroll through existing workspaces with mainMod + scroll
      "$mainMod, mouse_down, workspace, e+1"
      "$mainMod, mouse_up, workspace, e-1"
      "$mainMod, right, workspace, e+1"
      "$mainMod, left, workspace, e-1"
      "$mainMod SHIFT, h, movewindow, l"
      "$mainMod SHIFT, l, movewindow, r"
      "$mainMod SHIFT, j, movewindow, d"
      "$mainMod SHIFT, k, movewindow, u"

      # Media
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioPrev, exec, playerctl previous"
      ", XF86AudioNext, exec, playerctl next"

      # Misc
      '', Print, exec, grimblast --notify copysave screen ~/Pictures/Screenshots/$(date "+%d-%m-%y_%H:%M:%S").png''
      ''ctrl, Print, exec, grimblast --notify copysave area ~/Pictures/Screenshots/$(date "+%d-%m-%y_%H:%M").png''
      "$mainMod SHIFT, P, exec, ~/.config/hypr/scripts/lock.sh"
      "$mainMod SHIFT, M, exec, pidof mpd || mpd; foot ncmpcpp "
      "$mainMod SHIFT, W, exec, ~/.config/hypr/scripts/wpnext.sh 9"
      "$mainMod SHIFT, O, exec, copyq show"
      "$mainMod SHIFT, D, exec, foot lfub"
      "$mainMod SHIFT, C, exec, foot cava"
      "$mainMod SHIFT, A, exec, foot pulsemixer"
      "$mainMod SHIFT, N, exec, foot nixos-rebuild switch --use-remote-sudo --flake /home/nick/nicks##myNixos --show-trace"

      # Reload ags
      "$mainMod SHIFT, R, exec, killall .ags-wrapped; ags"
      "$mainMod CTRL SHIFT, R, exec, killall .ags-wrapped; ags inspector"

      # Switch keyboard layout
      "$mainMod SHIFT, Space, exec, hyprctl switchxkblayout keychron-keychron-q3-keyboard next"
    ];

    bindl = [ ", F slash, exec, foot" ];

    bindm = [
      "$mainMod, mouse:272, movewindow"
      "$mainMod, mouse:273, resizewindow"
    ];

    binde = [
      ", XF86AudioRaiseVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ +2%"
      ", XF86AudioLowerVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ -2%"
      " CTRL, XF86AudioRaiseVolume, exec, pactl set-source-volume @DEFAULT_SOURCE@ +2%"
      " CTRL, XF86AudioLowerVolume, exec, pactl set-source-volume @DEFAULT_SOURCE@ -2%"
      ", XF86AudioMute, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle"
      " CTRL, XF86AudioMute, exec, pactl set-source-mute @DEFAULT_SOURCE@ toggle"
    ];
  };
}
