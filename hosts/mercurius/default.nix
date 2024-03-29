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
  };
}
