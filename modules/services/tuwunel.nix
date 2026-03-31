{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.opt.services.tuwunel;
in {
  options.opt.services.tuwunel = {
    enable = lib.mkEnableOption "tuwunel Matrix server";
    domain = lib.mkOption {
      type = lib.types.str;
    };
    registrationSecretPath = lib.mkOption {
      type = lib.types.path;
    };
  };

  config = let
    keyFile = "/run/livekit.key";
  in
    lib.mkIf cfg.enable {
      networking.firewall.allowedTCPPorts = [
        443
        8448
      ];
      services = {
        matrix-tuwunel = {
          enable = true;
          settings = {
            global = {
              port = [6167];
              server_name = cfg.domain;
              allow_registration = true;
              registration_token_file = cfg.registrationSecretPath;
              max_request_size = 25165820; # 24 MiB
              well_known = {
                client = "https://matrix.${cfg.domain}";
                server = "matrix.${cfg.domain}:443";
                livekit_url = "https://matrix.${cfg.domain}/livekit/jwt";
              };
            };
          };
        };

        nginx.virtualHosts = {
          ${cfg.domain}.locations = {
            "/.well-known/matrix" = {
              proxyPass = "http://127.0.0.1:6167/.well-known/matrix";
              extraConfig = ''
                proxy_set_header X-Forwarded-For $remote_addr;
                proxy_ssl_server_name on;
              '';
            };
          };

          "matrix.${cfg.domain}" = {
            forceSSL = true;
            useACMEHost = cfg.domain;
            locations = {
              "/" = {
                proxyPass = "http://127.0.0.1:6167";
                extraConfig = ''
                  proxy_set_header Host $host;
                  proxy_set_header X-Forwarded-For $remote_addr;
                  proxy_set_header X-Forwarded-Proto https;
                '';
              };
              "^~ /livekit/jwt/" = {
                priority = 400;
                proxyPass = "http://[::1]:${toString config.services.lk-jwt-service.port}/";
              };
              "^~ /livekit/sfu/" = {
                extraConfig = ''
                  proxy_send_timeout 120;
                  proxy_read_timeout 120;
                  proxy_buffering off;
                  proxy_set_header Accept-Encoding gzip;
                  proxy_set_header Upgrade $http_upgrade;
                  proxy_set_header Connection "upgrade";
                '';
                priority = 400;
                proxyPass = "http://[::1]:${toString config.services.livekit.settings.port}/";
                proxyWebsockets = true;
              };
            };
          };
        };

        livekit = {
          enable = true;
          openFirewall = true;
          settings.room.auto_create = false;
          inherit keyFile;
        };
        lk-jwt-service = {
          enable = true;
          livekitUrl = "wss://matrix.${cfg.domain}/livekit/sfu";
          inherit keyFile;
        };
      };

      systemd.services.livekit-key = {
        before = [
          "lk-jwt-service.service"
          "livekit.service"
        ];
        wantedBy = ["multi-user.target"];
        path = with pkgs; [
          livekit
          coreutils
          gawk
        ];
        script = ''
          echo "Key missing, generating key"
          echo "lk-jwt-service: $(livekit-server generate-keys | tail -1 | awk '{print $3}')" > "${keyFile}"
        '';
        serviceConfig.Type = "oneshot";
        unitConfig.ConditionPathExists = "!${keyFile}";
      };
      systemd.services.lk-jwt-service.environment.LIVEKIT_FULL_ACCESS_HOMESERVERS = cfg.domain;
    };
}
