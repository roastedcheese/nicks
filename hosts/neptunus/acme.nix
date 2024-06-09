{
  users.users.nginx.extraGroups = [ "acme" ];
  security.acme = {
    acceptTerms = true;
    defaults.email = "security@roastedcheese.org";
    certs."nromano.net" = {
      group = "nginx";
      extraDomainNames = [ "*.nromano.net" ];
      dnsProvider = "porkbun";
      credentialFiles = {
        "PORKBUN_API_KEY_FILE" = "/run/secrets/porkbun_api";
        "PORKBUN_SECRET_API_KEY_FILE" = "/run/secrets/porkbun_api_secret";
      };
    };
  };
}
