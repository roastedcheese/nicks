{ inputs, pkgs, ... }:
{
  imports = [ 
    ./disko.nix
    inputs.rock.nixosModules.fan-control
  ];

  nixpkgs.hostPlatform = "aarch64-linux";
  networking.hostName = "neptunus";

  services.rock5b-fan-control = {
    enable = true;
    package = inputs.rock.packages.${pkgs.system}.fan-control;
  };

  users = {
    mutableUsers = false;
    users = {
      nick.hashedPasswordFile = "/persist/passwords/nick";
      root.hashedPasswordFile = "/persist/passwords/root";
    };
  };

  opt.system = {
    roles.headless = true;
    impermanence = {
      enable = true;
      root = {
        device = "/dev/disk/by-partlabel/disk-root-root";
        subvolume = "root";
      };
      persistent = "/persist";
      directories = [ 
        "/home"
      ];
    };
  };

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = false;
    };

    initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "ahci"
    ];

    kernelParams = [
      "console=tty1"
      "console=ttyS0,1500000"
    ];
  };
}
