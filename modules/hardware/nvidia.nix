{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf mkDefault;
  cfg = config.opt.hardware.nvidia;
in 
{
  options.opt.hardware.nvidia.enable = mkEnableOption "the nvidia drivers";

  config = mkIf cfg.enable {
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = mkDefault true; # nvidia power management, experimental and can cause sleep/suspend to fail.
      powerManagement.finegrained = mkDefault false; # finegrained power management, turns off GPU when not in use, only works on newer GPUs.
      open = mkDefault true; # the open source kernel module, https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    };
  };
}
