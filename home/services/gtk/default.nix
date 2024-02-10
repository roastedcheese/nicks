{ pkgs, config, ... }:
{
  gtk = {
    theme = {
      name = "rose-pine-gtk";
      package = pkgs.rose-pine-gtk-theme;
    };

    font = {
      name = "Inter Nerd Font Mono";
      package = pkgs.inter;
    };

    cursorTheme.name = "BreezeX-RoséPine";
  };

  home.file.rose-pine-cursor = {
    source = ./rose-pine-cursor;
    target = ".icons/BreezeX-RoséPine";
    recursive = true;
  };

  home.file.themeIndex = {
    text = ''
      [Icon theme] 
      Inherits=BreezeX-RoséPine
    '';
    target = ".icons/default/index.theme";
  };
}
