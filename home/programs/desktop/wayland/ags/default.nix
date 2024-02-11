{ config, inputs, ... }:
{
  imports = [ inputs.ags.homeManagerModules.default ];

  programs.ags.enable = true;

  home.file.ags = { # Laziest port ever
    source = ./config;
    recursive = true;
    target = config.xdg.configHome + "/ags";
  };
}
