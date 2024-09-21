{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.opt.programs.mpv;
in {
  options.opt.programs.mpv.enable = mkEnableOption "mpv";

  config.home-manager.users.${config.opt.system.username}.programs.mpv = mkIf cfg.enable {
    enable = true;
    config = {
      slang = "en";
    };
    scripts = [pkgs.mpvScripts.mpris];
  };
}
