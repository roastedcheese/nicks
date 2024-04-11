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
    hardware.nvidia.enable = true;

    services.xdg.userDirs = {
      download = "misc/Downloads";
      music = "Music";
    };
  };
}
