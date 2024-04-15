# took inspiration from @notashelf's config
{ config, inputs, ... }:
{
  imports = [ inputs.snm.nixosModule ];

  mailserver = {
    enable = true;
    # mailDirectory = "/srv/storage/mail/vmail";
    # dkimKeyDirectory = "/srv/storage/mail/dkim";
    indexDir = "/var/index";
    fqdn = "mail.roastedcheese.org";
    domains = [ "roastedcheese.org" ];

    enableImap = true;
    enableImapSsl = true;
    hierarchySeparator = "/";

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

    mailboxes = {
      Drafts = {
        auto = "subscribe";
        specialUse = "Drafts";
      };
      Junk = {
        auto = "subscribe";
        specialUse = "Junk";
      };
      Sent = {
        auto = "subscribe";
        specialUse = "Sent";
      };
      Trash = {
        auto = "no";
        specialUse = "Trash";
      };
      Archive = {
        auto = "subscribe";
        specialUse = "Archive";
      };
    };

    fullTextSearch = {
      enable = true;
      autoIndex = true;
      indexAttachments = true;
      enforced = "body";
    };

    certificateScheme = "acme";

    vmailUserName = "vmail";
    vmailGroupName = "vmail";

    useFsLayout = true;
  };
  
  # Fix a crash on unstable
  services.dovecot2.sieve.extensions = [ "fileinto" ];
}
