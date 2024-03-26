{ pkgs, inputs, ... }:
{
  imports = [
    ./mpd.nix
    ./mpv.nix
    ./ncmpcpp.nix
    ./qbittorrent.nix
    ./games
  ];

  home.packages = builtins.attrValues {
    inherit (pkgs) gimp ffmpeg rnnoise-plugin tenacity sxiv;
    inherit (inputs.nixpkgs-stable.legacyPackages.${pkgs.system}) nicotine-plus;
  };
}
