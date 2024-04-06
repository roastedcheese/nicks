{ lib, config, pkgs, ... }:
let
  inherit (lib) mkOption types mkIf;
  cfg = config.opt.programs.fish;
in 
{
  options.opt.programs.fish.enable = mkOption {
    type = types.bool;
    default = true;
    description = "Wheter to enable fish shell";
  };

  config = mkIf cfg.enable {
    programs.fish.enable = true;
    users.defaultUserShell = pkgs.fish;
    environment.systemPackages = [ pkgs.zip pkgs.wget ];
  };
}
