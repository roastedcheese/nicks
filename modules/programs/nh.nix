{ inputs, lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.opt.programs.nh;
in 
{
  options.opt.programs.nh.enable = mkEnableOption "nh nix helper";
  config.programs.nh = mkIf cfg.enable {
    enable = true;
    flake = "${inputs.self}";
  };
}
