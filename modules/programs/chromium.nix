{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf ;
  cfg = config.opt.programs.chromium;
in 
{
  options.opt.programs.chromium = {
    enable = mkEnableOption "the chromium browser";
    vencord = mkEnableOption "the vencord extension for chromium";
  };

  config.home-manager.users.${config.opt.system.username} = mkIf cfg.enable {
    programs.chromium = {
      enable = true;
      package = pkgs.brave;
      commandLineArgs = [ "--ozone-platform=wayland" ];
      extensions = mkIf cfg.vencord [
        {
          id = "cbghhgpcnddeihccjmnadmkaejncjndb";
          version = "1.8.0";
        }
      ];
    };
  };
}
