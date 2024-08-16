{ pkgs, inputs, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix 
    ./acme.nix
    ./mailserver.nix
    ./znc.nix
    inputs.agenix.nixosModules.default
  ];

  time.timeZone = "Europe/Berlin";
  opt = {
    system.roles.headless = true;
    home.packages = let
      inherit (inputs.p2n.lib.mkPoetry2Nix { inherit pkgs; }) mkPoetryApplication;
    in [
      (mkPoetryApplication {
        projectDir = pkgs.applyPatches {  
          src = pkgs.fetchFromGitHub {
            owner = "nathom";
            repo = "streamrip";
            rev = "41c0c3e3a017207f803a232b1ce214891570a1d8";
            hash = "sha256-vYmOA5uehyLc+NkZ+Ryfri01ItvS8uOVOBtFm1nbPb0=";
          };
          patches = [ ./streamrip.patch ];
        };
      })
      pkgs.mktorrent
    ];
  };
  services = {
    openssh.settings.PermitRootLogin = lib.mkForce "prohibit-password"; # :P

    nginx = {
      enable = true;
      enableReload = true;
      virtualHosts."roastedcheese.org" = {
        default = true;
        useACMEHost = "roastedcheese.org";
        forceSSL = true;
        root = "/var/www";
      };
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
