{ lib, pkgs, config, inputs, ... }:
let
  inherit (lib) mkOption types mkIf mkEnableOption;
  mkGtk = n: pkg: {
    name = mkOption {
      type = types.str;
      default = n;
    };
    package = mkOption {
      type = types.nullOr types.package;
      default = pkg;
    };
  };
  cfg = config.opt.services.gtk;
in 
{
  options.opt.services.gtk = {
    enable = mkEnableOption "gtk";
    theme = mkGtk "rose-pine" pkgs.rose-pine-gtk-theme;
    font = mkGtk "Inter Nerd Font Mono" pkgs.rose-pine-gtk-theme;
    cursorTheme = mkGtk "BreezeX-RoséPine" null;
  };

  config.home-manager.users.${config.opt.system.username} = mkIf cfg.enable {
    inherit (config.opt.services) gtk;
    dconf.settings = let
      notNull = k: mkIf (k != null) k;
    in {
      "org/gnome/desktop/interface" = {
        gtk-theme = notNull cfg.theme.name;
        font-name = notNull cfg.font.name;
        cursor-theme = notNull cfg.cursorTheme.name;
      };
    };

    home.file = {
      rose-pine-cursor = {
        source = inputs.self.lib.niv.rose-pine-cursor + "/BreezeX-RosePine";
        target = ".icons/BreezeX-RoséPine";
        recursive = true;
      };

      themeIndex = {
        text = ''
          [Icon theme] 
          Inherits=BreezeX-RoséPine
        '';
        target = ".icons/default/index.theme";
      };
    };
  };
}
