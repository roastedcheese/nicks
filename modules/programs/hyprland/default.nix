{ lib, config, pkgs, inputs, ... }:
let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.opt.programs.hyprland;
  inherit (config.home-manager.users.${config.opt.system.username}.xdg) configHome;
  package = pkgs.hyprland.overrideAttrs (final: prev: {
    postPatch = ''
      # Useless 48MB default wallpapers
      rm assets/wall*.png
      tail -n 1 assets/meson.build > assets/meson.build

    '' + prev.postPatch;
  });
in 
{
  options.opt.programs.hyprland = {
    enable = mkEnableOption "hyprland with greetd";
    settings = {
      gapsIn = mkOption {
        type = types.int;
        default = 5;
      };
      gapsOut = mkOption {
        type = types.int;
        default = 12;
      };
    };
  };

  config = mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings.default_session.command = "${pkgs.greetd.greetd}/bin/agreety --cmd Hyprland";
    };

    programs.hyprland = {
      inherit package;
      enable = true;
    };

    home-manager.users.${config.opt.system.username} = {
      home.file.hyprScripts = {
        executable = true;
        recursive = true;
        source = ./scripts;
        target = "${configHome}/hypr/scripts";
      };

      home.packages = builtins.attrValues {
          inherit (pkgs) wofi swww swaylock swayidle glib wl-clipboard copyq rose-pine-gtk-theme;
          inherit (inputs.hyprcontrib.packages.${pkgs.system}) grimblast;
      };


      wayland.windowManager.hyprland = {
        inherit package;
        enable = true;
        settings = {
          monitor = builtins.attrValues (builtins.mapAttrs (n: v: "${n},${v},auto,auto") config.opt.hardware.displays);
          # fuck anime
          misc.disable_hyprland_logo = true;
          general.allow_tearing = true;
          exec-once = [
            "swww-daemon & ${configHome}/hypr/scripts/wp.sh"
            "swayidle -w timeout 300 '${configHome}/hypr/scripts/lock.sh'"
            "ags"
            "copyq"
          ];

          env = [
            "XCURSOR_SIZE,24"
            "LIBVA_DRIVER_NAME,nvidia"
            "XDG_SESSION_TYPE,wayland"
            "__GLX_VENDOR_LIBRARY_NAME,nvidia"
          ];

          input = {
            kb_layout = "us,it";

            follow_mouse = 1;

            touchpad.natural_scroll = "no";
          };

          general = {
            gaps_in = cfg.settings.gapsIn;
            gaps_out = cfg.settings.gapsOut;
            border_size = 0;
          };

          decoration = {
            rounding = 3;
            
            # blur = {
            #   enabled = true;
            #   size = 12;
            #   passes = 3;
            # };

            drop_shadow = "yes";
            shadow_range = 4;
            shadow_render_power = 3;
            "col.shadow" = "rgba(1a1a1aee)";
          };

          animations = {
            enabled = "yes";

            bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

            animation = [
              "windows, 1, 7, myBezier"
              "windowsOut, 1, 7, default, popin 80%"
              "border, 1, 10, default"
              "borderangle, 1, 8, default"
              "fade, 1, 7, default"
              "workspaces, 1, 6, default"
              "layers, 0,,, layersIn"
            ];
          };

          dwindle = {
            pseudotile = "yes";
            preserve_split = "yes";
          };

          master = {
            new_is_master = true;
          };

          gestures = {
            workspace_swipe = "off";
          };

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
            ''ctrl, Print, exec, grimblast --notify --freeze copysave area ~/Pictures/Screenshots/$(date "+%d-%m-%y_%H:%M").png''
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
      };
    };
  };
}
