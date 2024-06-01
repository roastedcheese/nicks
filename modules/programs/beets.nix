{ config, lib, pkgs, ... }:
let
  inherit (lib) mkOption types mkEnableOption mkIf;
  cfg = config.opt.programs.beets;
in 
{
  options.opt.programs.beets = {
    enable = mkEnableOption "beets music tagger";
    musicDir = mkOption {
      type = types.str;
      default = config.xdg.userDirs.music;
    };
  };

  config.home-manager.users.${config.opt.system.username} = mkIf cfg.enable {
    home.packages = [ pkgs.python311Packages.requests ];
    programs.beets = {
      enable = true;
      settings = {
        directory = cfg.musicDir;
        library = "~/.local/share/beets/library.db";
        plugins = [ "info" "missing" "fetchart"];
      };
    };
  };
}
