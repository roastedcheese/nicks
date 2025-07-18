{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    mkOption
    types
    mkEnableOption
    mkIf
    ;
  cfg = config.opt.programs.beets;
in {
  options.opt.programs.beets = {
    enable = mkEnableOption "beets music tagger";
    musicDir = mkOption {
      type = types.str;
      default = config.home-manager.users.${config.opt.system.username}.xdg.userDirs.music;
    };
  };

  config.home-manager.users.${config.opt.system.username} = mkIf cfg.enable {
    home.packages = with pkgs.python311Packages; [
      discogs-client
      requests
    ];
    programs.beets = {
      package = pkgs.beets.overrideAttrs {
        disabledTests = [
          # https://github.com/beetbox/beets/issues/5880
          "test_reject_different_art"
        ];
      };
      enable = true;
      settings = {
        directory = cfg.musicDir;
        library = "~/.local/share/beets/library.db";
        plugins = [
          "info"
          "missing"
          "fetchart"
          "lyrics"
          "scrub"
          "zero"
          "discogs"
        ];
        lyrics = {
          synced = "yes";
          sources = [
            "lrclib"
            "tekstowo"
            "genius"
          ];
        };
        zero = {
          fields = "comments";
          update_database = true;
        };
      };
    };
  };
}
