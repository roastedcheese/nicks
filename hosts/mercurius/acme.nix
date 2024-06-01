{
  users.users.nginx.extraGroups = [ "acme" ];
  services.nginx = {
    enable = true;
    virtualHosts = {
      "acmechallenge.roastedcheese.org" = {
        # Catchall vhost, will redirect users to HTTPS for all vhosts
        serverAliases = [ "*.roastedcheese.org" ];

        locations."/.well-known/acme-challenge" = {
          root = "/var/lib/acme/.challenges";
        };

        locations."/" = {
          return = "301 https://$host$request_uri";
        };
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "security@roastedcheese.org";
      webroot = "/var/lib/acme/.challenges";
    };
    certs."roastedcheese.org" = {
      group = "nginx";
      extraDomainNames = [
        "www.roastedcheese.org"
        "mail.roastedcheese.org"
      ];
    };
  };
}
