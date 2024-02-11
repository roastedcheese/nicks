{ pkgs, ... }:
{
  imports = [
    ./firefox
    ./gtk
    ./wayland
    ./xdg
    ./media
  ];
  home.packages = builtins.attrValues {
    inherit (pkgs)
      copyq libnotify keepassxc vorta borgbackup tor-browser libreoffice;
  };
}
