{ config, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
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
}
