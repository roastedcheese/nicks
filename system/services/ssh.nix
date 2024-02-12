{ lib, ... }:
{
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = lib.mkForce "no";
    settings.PasswordAuthentication = lib.mkForce false;
  };
}
