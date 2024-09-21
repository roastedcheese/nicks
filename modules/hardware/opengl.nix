{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.opt.hardware.opengl;
in {
  options.opt.hardware.opengl.enable = mkEnableOption "OpenGL";

  config.hardware.graphics = mkIf cfg.enable {
    enable = true;
    enable32Bit = true;
  };
}
