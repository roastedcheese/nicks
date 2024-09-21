{
  lib,
  pkgs,
  inputs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.opt.programs.qbittorrent;
  theme = inputs.self.lib.niv.qbt-theme + "/mumble-dark.qbtheme";
  home = config.home-manager.users.${config.opt.system.username};
in {
  options.opt.programs.qbittorrent.enable = mkEnableOption "qbittorrent";

  config.home-manager.users.${config.opt.system.username} = mkIf cfg.enable {
    home.packages = [pkgs.qbittorrent];
    home.file.qbtheme = {
      source = theme;
      target = home.xdg.configHome + "/qBittorrent/mumble-dark.qbtheme";
    };
  };
}
