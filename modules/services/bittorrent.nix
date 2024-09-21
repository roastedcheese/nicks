{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption types;
  cfg = config.opt.services.bittorrent;
in {
  options.opt.services.bittorrent = {
    enable = mkEnableOption "bittorrent setup with qbittorrent and prowlarr";
    prowlarr = mkEnableOption "prowlarr indexer";
    domain = mkOption {
      type = types.str;
    };
    port = mkOption {
      type = types.port;
      description = "bittorrent port";
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [cfg.port];
    services.prowlarr.enable = mkIf cfg.prowlarr true;
    systemd.packages = [pkgs.qbittorrent-nox];
    systemd.services."qbittorrent-nox@qbt" = {
      overrideStrategy = "asDropin";
      wantedBy = ["multi-user.target"];
    };

    users = {
      users = {
        "qbt".isNormalUser = true;
      };
      extraGroups.bittorrent = {
        members =
          [
            config.opt.system.username
            "qbt"
          ]
          ++ (lib.optional cfg.prowlarr "prowlarr");
      };
    };
    opt.home.packages = [
      pkgs.intermodal
      (pkgs.mktorrent.overrideAttrs (f: p: {
        src = pkgs.fetchFromGitHub {
          owner = "pobrn";
          repo = "mktorrent";
          rev = "de7d011b35458de1472665f50b96c9cf6c303f39";
          hash = "sha256-mLeyjcV/TcVDbM1adG29rk1prSJcuk0P4NrlLmPwU78=";
        };
      }))
    ];

    services.nginx.virtualHosts."bt.${cfg.domain}" = {
      forceSSL = true;
      useACMEHost = cfg.domain;
      locations = {
        "/qbt/" = {
          proxyPass = "http://localhost:8080/";
          extraConfig = ''
            proxy_http_version 1.1;

            proxy_set_header   Host               127.0.0.1:8080;
            proxy_set_header   X-Forwarded-Proto  $scheme;
            proxy_set_header   X-Forwarded-Host   $http_host;
            proxy_set_header   X-Forwarded-For    $remote_addr;
            proxy_cookie_path  /                  "/; Secure";
          '';
        };

        "/ss" = {
          proxyPass = "http://127.0.0.1:55110"; # Smoked salmon webserver
          extraConfig = ''
            proxy_http_version 1.1;
            proxy_set_header   Host               127.0.0.1:55110;
            proxy_set_header   X-Forwarded-Proto  $scheme;
            proxy_set_header   X-Forwarded-Host   $http_host;
            proxy_set_header   X-Forwarded-For    $remote_addr;
          '';
        };

        "/prowlarr" = mkIf cfg.prowlarr {
          proxyPass = "http://localhost:9696";
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Host $host;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_redirect off;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection $http_connection;
          '';
        };

        " /prowlarr(/[0-9]+)?/api" = mkIf cfg.prowlarr {
          proxyPass = "http://localhost:9696";
          extraConfig = ''
            auth_basic off;
          '';
        };
      };

      extraConfig = ''
        allow 192.168.1.0/24;
        deny all;
      '';
    };
  };
}
