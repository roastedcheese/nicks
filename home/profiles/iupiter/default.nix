{
  imports = [
    ../../desktop
    ../../terminal/desktop.nix
  ];

  wayland.windowManager.hyprland.settings.monitor = ",2560x1440@165,auto,auto";
}
