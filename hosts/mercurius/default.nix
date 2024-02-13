{ inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix 
    ./mailserver.nix
    inputs.agenix.nixosModules.default
  ];

  boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
  };

  networking.hostName = "mercurius";

  age.secrets.mailserver.file = inputs.self + "/secrets/mailserver.age";
}
