{ inputs, pkgs, config, ... }:
{
  imports = [ 
    ./disko.nix
    ./backup.nix
    inputs.rock.nixosModules.fan-control
    inputs.agenix.nixosModules.default
  ];

  age.secrets = { 
    slskd_env.file = "${inputs.self}/secrets/slskd_env.age";
    mail_backup.file = "${inputs.self}/secrets/mail_backup.age";
  };

  nixpkgs.hostPlatform = "aarch64-linux";
  networking.hostName = "neptunus";

  services = {
    rock5b-fan-control = {
      enable = true;
      package = inputs.rock.packages.${pkgs.system}.fan-control;
    };

    ddclient = {
      package = pkgs.ddclient.overrideAttrs {
        src = pkgs.fetchFromGitHub {
          owner = "ddclient";
          repo = "ddclient";
          rev = "282bb01e1761707297eb9d47d97848b50c36ad8d";
          sha256 = "sha256-QS1YjJq6cAIBzPv5BFtWpZE1LeaUPpxiftGt5c+qTgA=";
        };
      };
      enable = true;
      interval = "5min";
      configFile = "/root/ddclient.conf";
    };
  };

  opt = {
    services.navidrome = {
      enable = true;
      domain = "example.org";
    };

    services.slskd = {
      enable = true;
      domain = "example.org";
      envFile = config.age.secrets.slskd_env.path;
    };

    programs.beets = {
      enable = true;
      musicDir = "/srv/music";
    };

    system.roles.headless = true;
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

    kernelPackages = pkgs.linuxKernel.packages.linux_testing;
    kernelParams = [
      "console=tty1"
      "console=ttyS0,1500000"
    ];
  };
}
