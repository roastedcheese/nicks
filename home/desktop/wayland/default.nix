{ pkgs, ... }:
{
  imports = [
    ./hyprland
    ./ags
  ];

  home.packages = builtins.attrValues {
    inherit (pkgs) wofi swww swaylock swayidle glib wl-clipboard;
  };
}
