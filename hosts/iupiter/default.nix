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

  nixpkgs.config.allowUnfree = true;
  opt = {
    system.roles = {
      workstation = true;
      gaming = true;
    };
    hardware = {
      nvidia.enable = true;
      displays."" = "2560x1440@165";
    };

    services.xdg.userDirs = {
      download = "misc/Downloads";
      music = "Music";
    };

    programs.chromium = {
      enable = true;
      vencord = true;
    };
  };

  fileSystems.media = {
    device = "/dev/mapper/media";
    mountPoint = "/home/${config.opt.system.username}/Media";
    fsType = "ext4";
    encrypted = {
      enable = true;
      blkDev = "/dev/disk/by-uuid/655e6a3b-f08e-495e-aa53-0d8e6fb33943";
      label = "media";
      keyFile = "/mnt-root/etc/media.key";
    };
  };
}
