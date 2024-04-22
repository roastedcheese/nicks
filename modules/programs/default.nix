{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption optional;
  cfg = config.opt.programs;
in 
{
  imports = [
    ./gpg.nix
    ./hyprland
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
  ];

  options.opt.programs = {
    thunderbird.enable = mkEnableOption "thunderbird"; # TODO: write a proper module
    element.enable = mkEnableOption "element desktop";
  };

  config.opt.home.packages = with pkgs; [ niv tree zip mediainfo] ++ (optional cfg.thunderbird.enable pkgs.thunderbird) 
  ++ (optional cfg.element.enable pkgs.element-desktop);
}
