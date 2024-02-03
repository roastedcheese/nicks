{ config, ... }:
{
  xdg.userDirs = {
    enable = true;
    download = config.home.homeDirectory + "/misc/Downloads";
    music = config.home.homeDirectory + "/Media/Downloads/Music";
  };
}
