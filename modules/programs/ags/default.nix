{ lib, config, inputs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.opt.programs.ags;
in 
{

  options.opt.programs.ags.enable = mkEnableOption "Aylur's GTK Shell";

  config.home-manager.users.${config.opt.system.username} = mkIf cfg.enable {
    imports = [ inputs.ags.homeManagerModules.default ];
    programs.ags = {
      enable = true;
      configDir = ./config;
    };
  };
}
