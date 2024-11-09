{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.opt.programs.hyprland;
  inherit (config.home-manager.users.${config.opt.system.username}.xdg) configHome;
  package = inputs.hyprland.packages.${pkgs.system}.default.overrideAttrs (final: prev: {
    postPatch =
      ''
        # Useless 48MB default wallpapers
        rm assets/install/wall*.png
        tail -n 1 assets/meson.build > assets/meson.build

      ''
      + prev.postPatch;
  });
in {
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
      portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
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
        inherit (pkgs) wofi swww swaylock swayidle glib wl-clipboard rose-pine-gtk-theme jq pulsemixer;
        inherit (inputs.hyprcontrib.packages.${pkgs.system}) grimblast;
      };

      wayland.windowManager.hyprland = {
        enable = true;
        inherit package;
        settings = {
          debug.disable_logs = false;
          misc = {
            disable_hyprland_logo = true; # fuck anime
            enable_swallow = true;
            swallow_regex = "foot";
            swallow_exception_regex = ".*#ns.*";
          };
          cursor.allow_dumb_copy = true; # Should remove cursor from screenshots
          general.allow_tearing = true;

          exec-once = [
            "swww-daemon & ${configHome}/hypr/scripts/wp.sh"
            "swayidle -w timeout 300 '${configHome}/hypr/scripts/lock.sh'"
            "ags"
          ];

          general = {
            gaps_in = cfg.settings.gapsIn;
            gaps_out = cfg.settings.gapsOut;
            border_size = 0;
          };

          env =
            [
              "XCURSOR_SIZE,24"
            ]
            ++ (lib.optionals config.opt.hardware.nvidia.enable [
              "XDG_SESSION_TYPE,wayland"
              "__GLX_VENDOR_LIBRARY_NAME,nvidia"
            ]);

          monitor =
            builtins.attrValues (builtins.mapAttrs (n: v: "${n},${v},auto,auto") config.opt.hardware.displays)
            # TODO: Remove this if upgrading to 545+
            ++ lib.optional config.opt.hardware.nvidia.enable "Unknown-1,disable";

          input = {
            kb_layout = "graphite,us,it";
            follow_mouse = 1;
            touchpad.natural_scroll = "no";
            accel_profile = "flat";
            sensitivity = 0.4;
          };

          decoration = {
            rounding = 3;
            shadow = {
              enabled = true;
              range = 4;
              render_power = 3;
              color = "rgba(1a1a1aee)";
            };
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

          gestures = {
            workspace_swipe = "off";
          };

          "$mainMod" = "SUPER";
          bind = [
            # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
            "$mainMod, T, exec, foot"
            "$mainMod, C, killactive,"
            "$mainMod SHIFT, E, exit,"
            "$mainMod, V, togglefloating,"
            "$mainMod, R, exec, killall wofi || wofi --show drun"
            "$mainMod, Space, togglesplit,"
            "$mainMod, F, fullscreen"
            "$mainMod SHIFT, F, fullscreen, 1"

            "$mainMod, H, movefocus, l"
            "$mainMod, I, movefocus, r"
            "$mainMod, E, movefocus, u"
            "$mainMod, A, movefocus, d"
            "$mainMod SHIFT, H, movewindow, l"
            "$mainMod SHIFT, I, movewindow, r"
            "$mainMod SHIFT, E, movewindow, u"
            "$mainMod SHIFT, A, movewindow, d"

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
            "$mainMod, S, togglespecialworkspace, magic"
            "$mainMod CTRL, M, togglespecialworkspace, min"

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
            "$mainMod SHIFT, S, movetoworkspace, special:magic"
            "$mainMod, M, exec, bash ~/.config/hypr/scripts/minimize.sh special:min"

            # Scroll through existing workspaces with mainMod + scroll
            "$mainMod, mouse_down, workspace, e+1"
            "$mainMod, mouse_up, workspace, e-1"
            "$mainMod, right, workspace, e+1"
            "$mainMod, left, workspace, e-1"

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
            "$mainMod SHIFT, A, exec, foot pulsemixer"
            "$mainMod SHIFT, N, exec, foot nixos-rebuild switch --use-remote-sudo --flake /home/nick/nicks##myNixos --show-trace"

            # Reload ags
            "$mainMod SHIFT, R, exec, killall .ags-wrapped; ags"
            "$mainMod CTRL SHIFT, R, exec, killall .ags-wrapped; ags inspector"

            # Switch keyboard layout
            "$mainMod SHIFT, Space, exec, hyprctl switchxkblayout keychron-keychron-q3-keyboard next"
          ];

          bindl = [", F slash, exec, foot"];

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
