{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.opt.programs.zathura;
in 
{
  options.opt.programs.zathura.enable = mkEnableOption "zathura document viewer";

  config.home-manager.users.${config.opt.system.username}.programs = mkIf cfg.enable {
    zathura.enable = true;
    fish.shellAbbrs.z = mkIf config.opt.programs.fish.enable "zathura";
  };
}
