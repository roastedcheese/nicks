{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.opt.programs.hyprland;
in 
{
  options.opt.programs.hyprland.enable = mkEnableOption "hyprland with greetd";

  config = mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings.default_session.command = "${pkgs.greetd.greetd}/bin/agreety --cmd Hyprland";
    };
    programs.hyprland.enable = true;
  };
}
