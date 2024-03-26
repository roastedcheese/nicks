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
}
