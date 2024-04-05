{ inputs, pkgs, config, ... }:
{
  imports = [
    inputs.hyprland.homeManagerModules.default 
    ./binds.nix
  ];
  
  home.packages = [
    inputs.hyprcontrib.packages.${pkgs.system}.grimblast
    pkgs.rose-pine-gtk-theme
  ];


  home.file.hyprScripts = {
    executable = true;
    recursive = true;
    source = ./scripts;
    target = "${config.xdg.configHome}/hypr/scripts";
  }; 

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      # fuck anime
      misc.disable_hyprland_logo = true;

      exec-once = [
        "swww init & ${config.xdg.configHome}/hypr/scripts/wp.sh"
        ''dconf write /org/gnome/desktop/interface/font-name "'Inter Nerd Font Mono'" & dconf write /org/gnome/desktop/interface/cursor-theme "'BreezeX-RoséPine'" & copyq & dconf write /org/gnome/desktop/interface/gtk-theme "'rose-pine'"''
        "swayidle -w timeout 300 '${config.xdg.configHome}/hypr/scripts/lock.sh'"
        "ags"
      ];

      env = [
        "XCURSOR_SIZE,24"
        "LIBVA_DRIVER_NAME,nvidia"
        "XDG_SESSION_TYPE,wayland"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "WLR_NO_HARDWARE_CURSORS,1"
      ];

      input = {
        kb_layout = "us,it";

        follow_mouse = 1;

        touchpad.natural_scroll = "no";
      };
      general = {
        gaps_in = 5;
        gaps_out = 12;
        border_size = 0;
      };

      decoration = {
        rounding = 3;
        
        blur = {
          enabled = true;
          size = 12;
          passes = 3;
        };

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
    };
  };
}
