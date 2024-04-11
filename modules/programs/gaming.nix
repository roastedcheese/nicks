{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption optional;
  cfg = config.opt.programs.gaming;
in 
{
  options.opt.programs.gaming = {
    steam = mkEnableOption "steam";
    prism = mkEnableOption "prism launcher";
    heroic = mkEnableOption "heroic launcher";
  };

  config = {
    home-manager.users.${config.opt.system.username}.home.packages = (optional cfg.prism pkgs.prismlauncher) ++ (optional cfg.heroic pkgs.heroic); # TODO: fix minecraft
    programs.steam.enable = true;
  };
}
