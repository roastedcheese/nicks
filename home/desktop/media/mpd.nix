{ config, pkgs, ... }:
{
  home.packages = [ pkgs.mpdris2 pkgs.playerctl];
  services = {
    playerctld.enable = true;
    mpdris2.enable = true;

    mpd = {
      enable = true;
      dataDir = config.xdg.dataHome + "/mpd";
      dbFile = config.xdg.dataHome + "/mpd" + "/database";
      playlistDirectory = config.xdg.dataHome + "/mpd" + "/playlists";
      musicDirectory = config.xdg.userDirs.music;
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
