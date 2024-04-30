{ config, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
  };

  networking = {
    firewall.allowedTCPPorts = [ 2234 ]; # Soulseek
    hostName = "iupiter";
  };

  opt = {
    system.roles = {
      workstation = true;
      gaming = true;
    };
    nixpkgs.config.allowUnfree = true;
    hardware = {
      nvidia.enable = true;
      displays."" = "2560x1440@165";
    };

    services.xdg.userDirs = {
      download = "misc/Downloads";
      music = "Music";
    };
  };

  fileSystems.media = {
    device = "/dev/mapper/media";
    mountPoint = "/home/${config.opt.system.username}/Media";
    encrypted = {
      enable = true;
      blkDev = "/dev/disk/by-uuid/1aa6fea0-da16-4ffe-b58b-875197155793";
      label = "media";
      keyFile = "/mnt-root/etc/media.key";
    };
  };
}
