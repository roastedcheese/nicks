{
  imports = [
    ../../desktop
    ../../terminal/desktop.nix
  ];

  wayland.windowManager.hyprland.settings.monitor = ",1920x1080@60,auto,auto";
}
