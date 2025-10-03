{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkDefault;
  cfg = config.opt.hardware.nvidia;
in {
  options.opt.hardware.nvidia.enable = mkEnableOption "the nvidia drivers";

  config = mkIf cfg.enable {
    opt.hardware.opengl.enable = true;
    services.xserver.videoDrivers = ["nvidia"];
    boot.kernelParams = mkIf config.opt.programs.hyprland.enable [
      "nvidia-drm.fbdev=1"
      "nvidia_drm.modeset=1"
    ]; # Fixes ghost workspace issue

    hardware.nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.production;
      modesetting.enable = true;
      powerManagement.enable = true; # nvidia power management, experimental and can cause sleep/suspend to fail.
      powerManagement.finegrained = false; # finegrained power management, turns off GPU when not in use, only works on newer GPUs.
      open = true; # the open source kernel module, https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    };
  };
}
