{ lib, config, inputs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.opt.programs.foot;
  home = config.home-manager.users.${config.opt.system.username};
in
{
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
        main.include = "${home.xdg.configHome}/foot/themes/rose-pine";
        main.font = "Hack Nerd Font:size=12";
        cursor = {
          style = "beam";
          blink = "yes";
        };
      };
    };
  };
}
