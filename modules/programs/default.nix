{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.opt.programs;
in 
{
  imports = [
    ./gpg.nix
    ./fonts.nix
    ./hyprland
    ./nvim
    ./git.nix
    ./fish.nix
    ./firefox.nix
    ./fish.nix
  ];

  options.opt.programs = {
    thunderbird.enable = mkEnableOption "thunderbird"; # TODO: write a proper module
    element.enable = mkEnableOption "element desktop";
  };

  config.home-manager.users.${config.opt.system.username}.home = {
    packages = (mkIf cfg.thunderbird.enable [ pkgs.thunderbird ]) // (mkIf cfg.element.enable [ pkgs.element-desktop ]);
  };
}
