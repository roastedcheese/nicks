{ pkgs, self, config, ... }: # Unfortunately we still have to config it manually, this is just making the theme available
let
  theme = self.lib.pins.qbt-theme.outPath + "/mumble-dark.qbtheme";
in {
  home.packages = [ pkgs.qbittorrent ];
  home.file.qbtheme = {
    source = theme;
    target = config.xdg.configHome + "/qbittorrent/mumble-dark.qbtheme";
  };
}
