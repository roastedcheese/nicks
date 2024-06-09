{
  users.users.nginx.extraGroups = [ "acme" ];
  security.acme = {
    acceptTerms = true;
    defaults.email = "security@roastedcheese.org";
    certs."example.org" = {
      group = "nginx";
      extraDomainNames = [ "*.example.org" ];
      dnsProvider = "porkbun";
      credentialFiles = {
        "PORKBUN_API_KEY_FILE" = "/run/secrets/porkbun_api";
        "PORKBUN_SECRET_API_KEY_FILE" = "/run/secrets/porkbun_api_secret";
      };
    };
  };
}
