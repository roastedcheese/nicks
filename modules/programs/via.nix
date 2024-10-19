{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.opt.programs.via;
in {
  options.opt.programs.via.enable = lib.mkEnableOption "VIA for QMK";

  config = lib.mkIf cfg.enable {
    hardware.keyboard.qmk.enable = true;
    opt.home.packages = [pkgs.via];
    services.udev.packages = [pkgs.via];
  };
}
