{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.opt.hardware.opengl;
in 
{
  options.opt.hardware.opengl.enable = mkEnableOption "OpenGL";

  config.hardware.opengl = mkIf cfg.enable {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
}
