{ lib, ... }:
{
  imports = [ ./hardware-configuration.nix ];
  networking.hostName = "apollo";
  boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
  };

  networking.networkmanager.enable = lib.mkForce true;
}
