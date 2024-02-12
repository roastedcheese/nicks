{ lib, ... }:
{
  services.openssh = {
    enable = true;
    permitRootLogin = lib.mkForce false;
    settings.passwordAuthentication = false;
  };
}
