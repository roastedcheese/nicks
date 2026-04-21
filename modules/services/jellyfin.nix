{
  config,
  lib,
  ...
}: let
  cfg = config.opt.services.jellyfin;
in {
  options.opt.services.jellyfin = {
    enable = lib.mkEnableOption "jellyfin";
    domain = lib.mkOption {
      type = lib.types.str;
    };
  };

  config.services = lib.mkIf cfg.enable {
    jellyfin.enable = true;
    nginx = {
      enable = true;
      enableReload = true;
      virtualHosts."jellyfin.${cfg.domain}" = {
        forceSSL = true;
        useACMEHost = cfg.domain;
        extraConfig = ''
          client_max_body_size 20M;
        '';

        locations."/" = {
          proxyPass = "http://127.0.0.1:8096";
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header X-Forwarded-Protocol $scheme;
            proxy_set_header X-Forwarded-Host $http_host;

            # Disable buffering when the nginx proxy gets very resource heavy upon streaming
            proxy_buffering off;
          '';
        };

        locations."/socket" = {
          # Proxy Jellyfin Websockets traffic
          proxyPass = "http://127.0.0.1:8096";
          extraConfig = ''
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header X-Forwarded-Protocol $scheme;
            proxy_set_header X-Forwarded-Host $http_host;
          '';
        };
      };
    };
  };
}
