{
  inputs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.opt.services.mailserver;
in {
  imports = [inputs.snm.nixosModule];

  options.opt.services.mailserver = {
    enable = mkEnableOption "Simple NixOS Mailserver";
    stateVersion = mkOption {
      type = types.int;
    };
    domain = mkOption {
      type = types.str;
      description = "Base domain name used for the mailserver. The mailserver itself will live under the \"mail.\" subdomain. Note that this module is not suited for more complex configurations e.g. with multiple domains.";
      example = "example.org";
    };

    mailboxes = mkOption {
      type = types.attrsOf types.attrs;
      default = {
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
    };

    accounts = mkOption {
      type = types.attrs;
      description = "SNM account config"; # Very lazy
    };
  };

  config.mailserver = mkIf cfg.enable {
    enable = true;
    inherit (cfg) stateVersion;
    indexDir = "/var/mail/index";
    sieveDirectory = "/var/mail/sieve";
    fqdn = "mail.${cfg.domain}";
    domains = [cfg.domain];
    localDnsResolver = false;

    storage = {
      directoryLayout = "fs";
      path = "/var/mail/vmail";
      owner = "vmail";
      group = "vmail";
    };

    enableImap = true;
    enableImapSsl = true;
    hierarchySeparator = "/";

    inherit (cfg) mailboxes accounts;
    fullTextSearch = {
      enable = true;
      autoIndex = true;
      enforced = "body";
    };

    x509.useACMEHost = cfg.domain;
  };
}
