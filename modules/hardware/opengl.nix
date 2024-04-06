{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.opt.opengl;
in 
{
  options.opt.opengl.enable = mkEnableOption "OpenGL";

  config.hardware.opengl = mkIf cfg.enable {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
}
