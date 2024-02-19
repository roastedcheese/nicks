{ config, pkgs, ... }:
{
  services =  {
    # Borrowed from @notashelf
    postgresql = {
      initialScript = pkgs.writeText "synapse-init.sql" ''
        CREATE ROLE "synapse" WITH LOGIN PASSWORD 'synapse';
        CREATE DATABASE "synapse" WITH OWNER "synapse"
          TEMPLATE template0
          LC_COLLATE = "C"
          LC_CTYPE = "C";
      '';
    };

    caddy = {
      enable = true;
      extraConfig = ''
        roastedcheese.org {
          root * /var/www
          header /.well-known/matrix/* Content-Type application/json
          header /.well-known/matrix/* Access-Control-Allow-Origin *
          respond /.well-known/matrix/server `{"m.server": "matrix.roastedcheese.org:443"}`
          respond /.well-known/matrix/client `{"m.homeserver":{"base_url":"https://matrix.roastedcheese.org"},"m.identity_server":{"base_url":"https://identity.roastedcheese.org"}}`
        }

        matrix.roastedcheese.org {
            reverse_proxy /_matrix/* localhost:8008
            reverse_proxy /_synapse/client/* localhost:8008
        }
      '';
    };
  
    matrix-synapse = {
      enable = true;
      settings = { 
        server_name = "roastedcheese.org";
        public_baseurl = "https://roastedcheese.org";

        enable_registration = true;
        registration_requires_token = true;

        report_stats = false;

        database = {
          name = "psycopg2";
          args = {
            user = "synapse";
            password = "synapse";
            dbname = "synapse";
            host = "/run/postgresql";
            cp_min = 5;
            cp_max = 10;
          };
        };

        media_retention.remote_media_lifetime = "30d";
        max_upload_size = "100M";
        url_preview_enabled = true;
        url_preview_ip_range_blacklist = [
            "127.0.0.0/8"
            "10.0.0.0/8"
            "172.16.0.0/12"
            "192.168.0.0/16"
            "100.64.0.0/10"
            "192.0.0.0/24"
            "169.254.0.0/16"
            "192.88.99.0/24"
            "198.18.0.0/15"
            "192.0.2.0/24"
            "198.51.100.0/24"
            "203.0.113.0/24"
            "224.0.0.0/4"
            "::1/128"
            "fe80::/10"
            "fc00::/7"
            "2001:db8::/32"
            "ff00::/8"
            "fec0::/10"
        ];

        listeners = [{
          port = 8008;
          bind_addresses = ["127.0.0.1"];
          tls = false;
          type = "http";
          x_forwarded = true;
          resources = [{
            names = [ "client" "federation" ];
            compress = true;
          }];
        }];

        # Send notifications and password reset
        email = {
          smtp_host = "email.roastedcheese.org";
          smtp_port = 465;
          smtp_user = "matrix";
          smtp_pass = config.age.secrets.matrix_mail.path;
          force_tls = true;
          notif_from = "matrix@roastedcheese.org";
          enable_notifs = true;
          notif_for_new_users = false;
        };
      };
    };
  };
}
