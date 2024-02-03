{ config, ... }:
{
  home.file.footThemes = {
    recursive = true;
    source = ./themes;
    target = "${config.xdg.configHome}/foot/themes";
  };
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main.include = "${config.xdg.configHome}/foot/themes/rose-pine";
      main.font = "Hack Nerd Font:size=12";

      cursor = {
        style = "beam";
        blink = "yes";
      };
    };
  };
}
