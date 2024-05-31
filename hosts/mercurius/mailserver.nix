{ config, ... }:
{
  users.users.${config.opt.system.username}.extraGroups = [ "vmail" ];
  opt.services.mailserver = {
    enable = true;
    domain = "roastedcheese.org";

    # A list of all login accounts. To create the password hashes, use
    # nix-shell -p mkpasswd --run 'mkpasswd -sm bcrypt'
    loginAccounts = {
      "cheese@roastedcheese.org" = {
        hashedPasswordFile = config.age.secrets.mailserver.path;
        aliases = [
          "me"
          "cheese"
          "me@roastedcheese.org"
          "postmaster@roastedcheese.org"
          "security@roastedcheese.org"
        ];
      };

      "noreply@roastedcheese.org" = {
        aliases = ["noreply"];
        hashedPasswordFile = config.age.secrets.mailserver.path; # Who needs different passwords
        sendOnly = true;
        sendOnlyRejectMessage = "no reply";
      };

      "bill@roastedcheese.org" = { # Bill
        hashedPasswordFile = config.age.secrets.mailserver.path;
      };

      "matrix@roastedcheese.org" = {
        hashedPasswordFile = config.age.secrets.mailserver_matrix.path;
        sendOnly = true;
        sendOnlyRejectMessage = "no reply";
      };
    };
  };
}
