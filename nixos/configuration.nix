{ config, lib, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./nvidia.nix
      ./packages.nix
      ./systemd.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
# boot.kernelParams = [ "loglevel=4" "nvidia-drm.modeset=1" "nvidia.NVreg_PreserveVideoMemoryAllocations=1" "nvidia.NVreg_OpenRmEnableUnsupportedGpus=1" "amd_iommu=on" "iommu=pt" "video=efifb:off"];

  users.defaultUserShell = pkgs.zsh;

  networking.hostName = "nixdesktop"; # Define your hostname.
  networking.dhcpcd.wait = "background";

  services.automatic-timezoned.enable = true;
  time.timeZone = "Europe/Rome";

# Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

# Enable CUPS to print documents.
 services.printing.enable = true;

  users.users.nick = {
     isNormalUser = true;
     extraGroups = [ "wheel" "libvirtd"]; 
     packages = with pkgs; [
     ]; };

# rtkit is optional but recommended
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

# List services that you want to enable:

  programs.adb.enable = true;
  programs.hyprland.enable = true;
  programs.zsh.enable = true;
#  virtualisation.libvirtd.enable = true;
#  programs.virt-manager.enable = true;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.greetd}/bin/agreety --cmd Hyprland";
      };
    };
  };

# Open ports in the firewall.
# networking.firewall.allowedTCPPorts = [ ... ];
# networking.firewall.allowedUDPPorts = [ ... ];
# Or disable the firewall altogether.
# networking.firewall.enable = false;

# Copy the NixOS configuration file and link it from the resulting system
# (/run/current-system/configuration.nix). This is useful in case you
# accidentally delete configuration.nix.
  system.copySystemConfiguration = false;

# This value determines the NixOS release from which the default
# settings for stateful data, like file locations and database versions
# on your system were taken. It's perfectly fine and recommended to leave
# this value at the release version of the first install of this system.
# Before changing this value read the documentation for this option
# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}

