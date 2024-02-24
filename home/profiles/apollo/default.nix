{ lib, ... }:
{
  imports = [
    ../../desktop
    ../../terminal/desktop.nix
  ];

  wayland.windowManager.hyprland.settings = {
    monitor = ",1920x1080@60,auto,auto";
    general = lib.mkForce {
      gaps_in = 0;
      gaps_out = 0;
      border_size = 0;
    };
  };
}
