{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.opt.programs.yt-dlp;
in 
{
  options.opt.programs.yt-dlp.enable = mkEnableOption "yt-dlp";

  config.home-manager.users.${config.opt.system.username}.programs.yt-dlp = mkIf cfg.enable {
    enable = true; # TODO: stuff idk
  };
}
