{ inputs, pkgs, ... }:
{
  imports = [ 
    ./hardware-configuration.nix
    ./nvidia.nix
    ./packages.nix
    ./systemd.nix
    ./services.nix
  ];

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
    nixPath = [ "nixpkgs=flake:nixpkgs" ];
    registry.nixpkgs.flake = inputs.nixpkgs;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "iupiter"; # Define your hostname.
  networking.dhcpcd.wait = "background";

  time.timeZone = "Europe/Rome";

  i18n.defaultLocale = "en_US.UTF-8";

  users.users.nick = {
     isNormalUser = true;
     extraGroups = [ "wheel" "libvirtd"]; 
  };
  users.defaultUserShell = pkgs.zsh;

  security.rtkit.enable = true;

  programs = {
    adb.enable = true;
    hyprland.enable = true;
    zsh.enable = true;
  };
#  virtualisation.libvirtd.enable = true;
#  programs.virt-manager.enable = true;

  system.stateVersion = "23.11";
}
