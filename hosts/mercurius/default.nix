{ inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix 
    ./mailserver.nix
    ./znc.nix
    inputs.agenix.nixosModules.default
  ];

  boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "mercurius";
    domain = "roastedcheese.org";
    firewall.allowedTCPPorts = [ 80 443 8008 8448 ];
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

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "security@roastedcheese.org";
      webroot = "/var/www";
    };
    certs."roastedcheese.org".extraDomainNames = [
      "www.roastedcheese.org"
      "mail.roastedcheese.org"
    ];
  };
  services.caddy = {
    enable = true;
    extraConfig = ''
      {
        auto_https off
      }
      roastedcheese.org {
        root * /var/www
      }
    '';
  };
}
