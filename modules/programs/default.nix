{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption optional;
  cfg = config.opt.programs;
in 
{
  imports = [
    ./chromium.nix
    ./gpg.nix
    ./hyprland
    ./nh.nix
    ./nvim
    ./git.nix
    ./fish.nix
    ./firefox.nix
    ./fish.nix
    ./eza.nix
    ./foot.nix
    ./ncmpcpp.nix
    ./mpv.nix
    ./gaming.nix
    ./qbittorrent.nix
    ./starship.nix
    ./nicotineplus.nix
    ./ags
    ./zathura.nix
    ./ssh.nix
    ./yt-dlp.nix
    ./beets.nix
  ];

  options.opt.programs = {
    thunderbird.enable = mkEnableOption "thunderbird"; # TODO: write a proper module
    element.enable = mkEnableOption "element desktop";
  };

  config.opt.home.packages = with pkgs; [ glow niv tree zip mediainfo rename ] ++ (optional cfg.thunderbird.enable pkgs.thunderbird) 
    ++ (optional cfg.element.enable pkgs.element-desktop);
}
