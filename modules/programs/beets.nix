{ options, config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.opt.programs.beets;
in 
{
  options.opt.programs.beets.enable = mkEnableOption "beets music tagger";

  config.home-manager.users.${config.opt.system.username} = mkIf cfg.enable {
    programs.beets = {
      enable = true;
      settings = {
        directory = "~/Media/Downloads/Music";
        library = "~/.local/share/beets/library.db";
        plugins = [ "info" "missing" ];
      };
    };
  };
}
