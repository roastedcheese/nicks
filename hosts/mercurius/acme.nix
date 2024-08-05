{
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "security@roastedcheese.org";
      webroot = "/var/lib/acme/acme-challenge";
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
