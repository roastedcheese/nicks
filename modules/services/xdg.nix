{ lib, config, pkgs, ... }:
let
  inherit (lib) mkOption types mkEnableOption;
  mkDirOption = name: mkOption {
    type = with types; nullOr (coercedTo path toString str);
    default = name;
    description = "The ${name} directory, under ~";
  };
  cfg = config.opt.services.xdg;
  home = config.home-manager.users.${config.opt.system.username};
in 
{
  options.opt.services.xdg = {
    enable = mkEnableOption "xdg";
    userDirs = {
      desktop = mkDirOption "Desktop";
      documents = mkDirOption "Documents";
      download = mkDirOption "Downloads";
      music = mkDirOption "Music";
      pictures = mkDirOption "Pictures";
      publicShare = mkDirOption "Public";
      templates = mkDirOption "Templates";
      videos = mkDirOption "Videos";
    };
  };

  config.home-manager.users.${config.opt.system.username}.xdg = {
    enable = true;
    desktopEntries = {
      firefox-logins = {
        name = "Firefox (logins)";
        type = "Application";
        exec = "${pkgs.firefox}/bin/firefox -P logins";
      };

      steam = {
        name = "Steam";
        type = "Application";
        exec = "${pkgs.steam}/bin/steam";
      };
    };

    userDirs = (builtins.mapAttrs (name: value: "${home.home.homeDirectory}/${value}") cfg.userDirs) // { enable = true; };
  };
}
