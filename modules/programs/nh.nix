{ inputs, lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.opt.programs.nh;
  home = config.home-manager.users.${config.opt.system.username}.home.homeDirectory;
in 
{
  options.opt.programs.nh.enable = mkEnableOption "nh nix helper";
  config.programs.nh = mkIf cfg.enable {
    enable = true;
    flake = "${home}/nicks";
  };
}
