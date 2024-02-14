{ pkgs, ... }:
{
  imports = [
    ./mpd.nix
    ./mpv.nix
    ./ncmpcpp.nix
    ./qbittorrent.nix
  ];

  home.packages = builtins.attrValues {
    inherit (pkgs) nicotine-plus gimp ffmpeg rnnoise-plugin tenacity sxiv;
  };
}
