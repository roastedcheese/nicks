{ lib, config, pkgs, ... }:
let
  inherit (lib) mkOption types mkEnableOption mkIf;
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

  config.home-manager.users.${config.opt.system.username}.xdg = mkIf cfg.enable {
    enable = true;

    userDirs = (builtins.mapAttrs (name: value: "${home.home.homeDirectory}/${value}") cfg.userDirs) // { enable = true; };
  };
}
