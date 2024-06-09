{ inputs, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix 
    ./acme.nix
    ./mailserver.nix
    ./znc.nix
    inputs.agenix.nixosModules.default
  ];

  opt.system.roles.headless = true;
  services = {
    openssh.settings.PermitRootLogin = lib.mkForce "prohibit-password"; # :P
    nginx.virtualHosts."roastedcheese.org" = {
      default = true;
      useACMEHost = "roastedcheese.org";
      forceSSL = true;
      root = "/var/www";
    };
  };
  boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
  };


  networking = {
    hostName = "mercurius";
    domain = "roastedcheese.org";
    firewall.allowedTCPPorts = [ 80 443 ];
  };

  age.secrets = {
    mailserver.file = inputs.self + "/secrets/mailserver.age";
    mailserver_matrix.file = inputs.self + "/secrets/mailserver_matrix.age";
    # We need it unhashed for matrix
    matrix_mail.file = inputs.self + "/secrets/matrix_mail.age";
    matrix_secret.file = inputs.self + "/secrets/matrix_secret.age";

    znc_admin.file = inputs.self + "/secrets/znc_admin.age";
    znc_user.file = inputs.self + "/secrets/znc_user.age";
  };
}
