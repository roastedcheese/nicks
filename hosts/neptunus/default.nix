{ inputs, pkgs, ... }:
{
  imports = [ 
    ./disko.nix
    ./backup.nix
    inputs.rock.nixosModules.fan-control
  ];

  nixpkgs.hostPlatform = "aarch64-linux";
  networking.hostName = "neptunus";

  services.rock5b-fan-control = {
    enable = true;
    package = inputs.rock.packages.${pkgs.system}.fan-control;
  };

  opt.system.roles.headless = true;

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

    kernelPackages = pkgs.linuxKernel.packages.linux_testing;
    kernelParams = [
      "console=tty1"
      "console=ttyS0,1500000"
    ];
  };
}
