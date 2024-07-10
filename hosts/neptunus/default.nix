{ inputs, pkgs, ... }:
{
  imports = [ 
    ./disko.nix
    ./backup.nix
    ./acme.nix
    inputs.rock.nixosModules.fan-control
    inputs.agenix.nixosModules.default
  ];
  time.timeZone = "Europe/Rome";

  age.secrets = { 
    slskd_env.file = "${inputs.self}/secrets/slskd_env.age";
    mail_backup.file = "${inputs.self}/secrets/mail_backup.age";
  };

  nixpkgs.hostPlatform = "aarch64-linux";
  networking = {
    hostName = "neptunus";
    hosts."192.168.1.99" = [ "bt.example.org" ];
  };

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
      interval = "3min";
      configFile = "/root/ddclient.conf"; # FIXME: cachefile write and stuff
    };

    nginx = {
      logError = "stderr notice";
      virtualHosts."example.org" = {
        default = true;
        useACMEHost = "example.org";
        forceSSL = true;
        root = "/var/www";
      };
    };
  };

  opt = {
    services = {
      navidrome = {
        enable = true;
        domain = "example.org";
      };
      bittorrent = {
        enable = true;
        domain = "example.org";
      };
      vaultwarden = {
        enable = true;
        domain = "example.org";
      };
    };

    programs.beets = {
      enable = true;
      musicDir = "/srv/music";
    };

    system.roles.headless = true;
    home.packages = let
      inherit (inputs.p2n.lib.mkPoetry2Nix { inherit pkgs; }) mkPoetryApplication;
    in with pkgs; [
      (mkPoetryApplication {
        projectDir = pkgs.applyPatches {  
          src = pkgs.fetchFromGitHub {
            owner = "nathom";
            repo = "streamrip";
            rev = "41c0c3e3a017207f803a232b1ce214891570a1d8";
            hash = "sha256-vYmOA5uehyLc+NkZ+Ryfri01ItvS8uOVOBtFm1nbPb0=";
          };
          patches = [ ./streamrip.patch ]; # I hate python so much
        };
      })
      sox flac lame rename
    ];
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
    kernel.sysctl."fs.inotify.max_user_watches" = 1048576;
  };
}
