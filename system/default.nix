{
  imports = [ 
    ./hardware/hardware-configuration.nix
    ./hardware/nvidia.nix
    ./packages.nix
    ./services
    ./security.nix
    ./nix.nix # goofy name
    ./programs.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "iupiter";

  # This way it forks immediately and doesn't slow down boot
  networking.dhcpcd.wait = "background";

  time.timeZone = "Europe/Rome";

  i18n.defaultLocale = "en_US.UTF-8";

  users.users.nick = {
     isNormalUser = true;
     extraGroups = [ "wheel" "libvirtd"]; 
  };

  # no change this
  system.stateVersion = "23.11";
}
