{ pkgs, config, ... }:
{
  users = {
    users = {
      "znc-admin" = {
        isSystemUser = true;
        group = "znc-admin";
        hashedPasswordFile = config.age.secrets.znc_admin.path;
      };
      "roastedcheese" = {
        isSystemUser = true;
        group = "znc-user";
        hashedPasswordFile = config.age.secrets.znc_user.path;
      };
      znc.extraGroups = [ "nginx" "sasl" ];
    };
    groups = { "znc-admin" = {}; "znc-user" = {}; };
  };

  services.saslauthd.enable = true;

  environment.etc = {
    "pam.d/znc" = {
      source = pkgs.writeText "znc.pam" ''
        # Account management.
        account required pam_unix.so

        # Authentication management.
        auth sufficient pam_unix.so likeauth try_first_pass
        auth required pam_deny.so

        # Password management.
        password sufficient pam_unix.so nullok sha512

        # Session management.
        session required pam_env.so conffile=/etc/pam/environment readenv=0
        session required pam_unix.so
      '';
    };
  };

  # znc service config has some hardening options that otherwise block
  # interaction with saslauthd's unix socket
  systemd.services.znc.serviceConfig.RestrictAddressFamilies = [ "AF_UNIX" ];

  services.znc = {
    enable = true;
    mutable = false;
    useLegacyConfig = false;
    openFirewall = true;
    modulePackages = [ pkgs.zncModules.backlog ];
    confOptions.modules = [ "adminlog" ];
    config = let
      certDir = "/var/lib/acme/roastedcheese.org";
    in {
      LoadModule = [ "adminlog" "cyrusauth saslauthd" "log" ];
      SSLCertFile = certDir + "/fullchain.pem";
      SSLDHParamFile = certDir + "/fullchain.pem";
      SSLKeyFile = certDir + "/key.pem";
      Listener.l = {
        Port = 6697;
        IPv4 = true;
        IPv6 = true;
        SSL = true;
      };

      User = {
        "znc-admin" = {
          Admin = true;
          Pass = "md5#::#::#";
        };
        "roastedcheese" = {
          Pass = "md5#::#::#";
          Nick = "RoastedCheese";
          AltNick = "RoastedCheese_";
          Ident = "cheese";
          QuitMsg = "see you";
          realname = "RoastedCheese";
          Network = {
            "liberachat" = {
              LoadModule = [ "sasl" "simple_away" "backlog" ];
              Server = "irc.libera.chat +6697";
              Chan."#nixos" = {};
            };
            "ops" = {
              LoadModule = [ "nickserv" "simple_away" "backlog"];
              Server = "irc.orpheus.network +7000";
            };
            "mam" = {
              LoadModule = [ "nickserv" "simple_away" "backlog"];
              Server = "irc.myanonamouse.net +6697";
            };
          };
        };
      };
    };
  };
}
