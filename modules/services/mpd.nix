{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.opt.services.mpd;
in 
{
  options.opt.services.mpd.enable = mkEnableOption "Music Player Daemon";

  config.home-manager.users.${config.opt.system.username}.services = mkIf cfg.enable {
    playerctld.enable = true;
    mpdris2.enable = true;

    mpd = {
      enable = true;
      dataDir = config.xdg.dataHome + "/mpd";
      dbFile = config.xdg.dataHome + "/mpd" + "/database";
      playlistDirectory = config.xdg.dataHome + "/mpd" + "/playlists";
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
}
