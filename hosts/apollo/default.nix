{ lib, ... }:
{
  imports = [ ./hardware-configuration.nix ];
  networking.hostName = "apollo";
  boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
  };
  time.timeZone = "Europe/Rome";

  networking.networkmanager.enable = lib.mkForce true;
  opt = {
    system.roles.workstation = true;
    services.ssh.enable = true;
  };
}
