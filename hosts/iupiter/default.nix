{ inputs, config, ... }:
{

  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];


  users = {
    mutableUsers = false; # Oh my fucking God
    users = {
      nick.hashedPasswordFile = "/persist/passwords/nick";
      root.hashedPasswordFile = "/persist/passwords/root";
    };
  };

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
    system = {
      roles = {
        workstation = true;
        gaming = true;
      };

      impermanence = {
        enable = true;
        root = {
          device = "/dev/mapper/root";
          subvolume = "root";
        };
        persistent = "/persist";
        files = [
          "/etc/media.key"
        ];
      };
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
}
