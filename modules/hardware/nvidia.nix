{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf mkDefault;
  cfg = config.opt.hardware.nvidia;
in 
{
  options.opt.hardware.nvidia.enable = mkEnableOption "the nvidia drivers";

  config = mkIf cfg.enable {
    opt.hardware.opengl.enable = true;
    services.xserver.videoDrivers = [ "nvidia" ];
    boot.kernelParams = mkIf config.opt.programs.hyprland.enable [ "nvidia-drm.fbdev=1" "nvidia_drm.modeset=1" ]; # Fixes ghost workspace issue

    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true; # nvidia power management, experimental and can cause sleep/suspend to fail.
      powerManagement.finegrained = false; # finegrained power management, turns off GPU when not in use, only works on newer GPUs.
      open = true; # the open source kernel module, https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus

      package = let # use 535 nvidia driver, https://github.com/NixOS/nixpkgs/blob/nixos-23.11/pkgs/os-specific/linux/nvidia-x11/default.nix#L20
          rcu_patch = pkgs.fetchpatch {
              url = "https://github.com/gentoo/gentoo/raw/c64caf53/x11-drivers/nvidia-drivers/files/nvidia-drivers-470.223.02-gpl-pfn_valid.patch";
              hash = "sha256-eZiQQp2S/asE7MfGvfe6dA/kdCvek9SYa/FFGp24dVg=";
          };

          linux_6_8_patch = pkgs.fetchpatch {
              url = "https://gist.github.com/joanbm/24f4d4f4ec69f0c37038a6cc9d132b43/raw/bacb9bf3617529d54cb9a57ae8dc9f29b41d4362/nvidia-470xx-fix-linux-6.8.patch";
              hash = "sha256-SPLC2uGdjHSy4h9i3YFjQ6se6OCdWYW6tlC0CtqmP50=";
              extraPrefix = "kernel/";
              stripLen = 1;
          };
      in
          config.boot.kernelPackages.nvidiaPackages.mkDriver {
              version = "535.129.03";
              sha256_64bit = "sha256-5tylYmomCMa7KgRs/LfBrzOLnpYafdkKwJu4oSb/AC4=";
              sha256_aarch64 = "sha256-i6jZYUV6JBvN+Rt21v4vNstHPIu9sC+2ZQpiLOLoWzM=";
              openSha256 = "sha256-/Hxod/LQ4CGZN1B1GRpgE/xgoYlkPpMh+n8L7tmxwjs=";
              settingsSha256 = "sha256-QKN/gLGlT+/hAdYKlkIjZTgvubzQTt4/ki5Y+2Zj3pk=";
              persistencedSha256 = "sha256-FRMqY5uAJzq3o+YdM2Mdjj8Df6/cuUUAnh52Ne4koME=";

              patches = [
                  rcu_patch
                  linux_6_8_patch
              ];
          };
      };
  };
}
