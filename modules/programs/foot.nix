{
  lib,
  config,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.opt.programs.foot;
  home = config.home-manager.users.${config.opt.system.username};
in {
  options.opt.programs.foot.enable = mkEnableOption "foot terminal"; # feet

  config.home-manager.users.${config.opt.system.username} = mkIf cfg.enable {
    home.file.footTheme = {
      source = inputs.self.lib.niv.foot-rose-pine;
      target = "${home.xdg.configHome}/foot/themes/rose-pine";
    };

    programs.foot = {
      enable = true;
      server.enable = true;
      settings = {
        main = {
          include = "${home.xdg.configHome}/foot/themes/rose-pine";
          font = "Hack Nerd Font:size=12";
        };
        cursor = {
          style = "beam";
          blink = "yes";
        };
        key-bindings = {
          scrollback-up-half-page = "Control+bracketleft";
          scrollback-down-half-page = "Control+bracketright";
          scrollback-up-page = "Control+braceleft";
          scrollback-down-page = "Control+braceright";
          scrollback-up-line = "Control+Shift+k";
          scrollback-down-line = "Control+Shift+j";
        };
      };
    };
  };
}
