{ pkgs, ... }:
{

  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];

  environment.systemPackages = [ pkgs.quickemu ];


  time.timeZone = "Europe/Rome";
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

  services.mullvad-vpn.enable = true;
  networking = {
    firewall.allowedTCPPorts = [ 2234 ]; # Soulseek
    hostName = "iupiter";
    hosts."192.168.1.99" = [ "bt.nromano.net" ];
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
    home.packages = with pkgs; [ mullvad-vpn gocryptfs ];

    hardware = {
      nvidia.enable = true;
      displays."" = "2560x1440@165";
    };


    services.xdg.userDirs = {
      download = "misc/Downloads";
      music = "Music";
    };
  };

  virtualisation.libvirtd.enable = true;
}
