{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.opt.programs.obs;
in {
  options.opt.programs.obs.enable = lib.mkEnableOption "obs studio";
  config.programs.obs-studio = lib.mkIf cfg.enable {
    enable = true;
    enableVirtualCamera = true;
  };
}
