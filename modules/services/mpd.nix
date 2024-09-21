{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.opt.services.mpd;
  home = config.home-manager.users.${config.opt.system.username};
in {
  options.opt.services.mpd.enable = mkEnableOption "Music Player Daemon";

  config.home-manager.users.${config.opt.system.username} = {
    home.packages = [pkgs.playerctl];
    services = mkIf cfg.enable {
      playerctld.enable = true;
      mpdris2.enable = true;
      mpd = {
        enable = true;
        dataDir = home.xdg.dataHome + "/mpd";
        dbFile = home.xdg.dataHome + "/mpd" + "/database";
        playlistDirectory = home.xdg.dataHome + "/mpd" + "/playlists";
        extraConfig = ''
          input {
            plugin "curl"
          }

          audio_output {
                  type            "pipewire"
                  name            "PipeWire Sound Server"
          }

          audio_output {
              type                    "fifo"
              name                    "toggle_visualizer"
              path                    "/tmp/mpd.fifo"
              format                  "44100:16:2"
          }
        '';
      };
    };
  };
}
