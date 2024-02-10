{ pkgs, ... }:
{
  home.packages = builtins.attrValues {
    inherit (pkgs) swww swaylock swayidle libnotify glib keepassxc nicotine-plus qbittorrent;
  };
}
