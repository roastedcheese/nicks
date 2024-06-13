{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf mkOption types;
  cfg = config.opt.services.bittorrent;
in 
{
  options.opt.services.bittorrent = {
    enable = mkEnableOption "bittorrent setup with qbittorrent and prowlarr";
    domain = mkOption {
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 27194 ];
    services = {
      prowlarr.enable = true;
      lidarr.enable = true;
    };
    systemd.packages = [ pkgs.qbittorrent-nox ];
    systemd.services."qbittorrent-nox@qbt" = {
      overrideStrategy = "asDropin";
      wantedBy = [ "multi-user.target" ];
    };

    users = {
      users = {
        "qbt".isNormalUser = true;
      };
      extraGroups.bittorrent = {
        members = [
          config.opt.system.username
          "lidarr"
          "prowlarr"
          "qbt"
        ];
      };
    };
    opt.home.packages = [ pkgs.mktorrent ];

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

        "/prowlarr" = {
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

        " /prowlarr(/[0-9]+)?/api" = {
          proxyPass = "http://localhost:9696";
          extraConfig = ''
            auth_basic off;
          '';
        };
        "/lidarr" = {
          proxyPass = "http://localhost:8686";
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

        " /lidarr/api" = {
          proxyPass = "http://localhost:8686";
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
