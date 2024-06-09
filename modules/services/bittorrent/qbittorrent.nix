{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf mkOption types;
  cfg = config.opt.services.qbittorrent;
in 
{
  options.opt.services.qbittorrent = {
    enable = mkEnableOption "qbittorrent-nox";
    domain = mkOption {
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    systemd.packages = [ pkgs.qbittorrent-nox ];
    systemd.services."qbittorrent-nox@qbt" = {
      overrideStrategy = "asDropin";
      wantedBy = [ "multi-user.target" ];
    };

    users = {
      users."qbt" = {
        isNormalUser = true;
        group = "bittorrent";
      };
      groups.bittorrent = {};
    };

    services.nginx.virtualHosts."bt.${cfg.domain}" = {
      forceSSL = true;
      useACMEHost = cfg.domain;
      locations."/qbt/" = {
        proxyPass = "http://localhost:8080/";
        extraConfig = ''
          proxy_http_version 1.1;
          http2_push_preload on;

          proxy_set_header   Host               127.0.0.1:8080;
          proxy_set_header   X-Forwarded-Proto  $scheme;
          proxy_set_header   X-Forwarded-Host   $http_host;
          proxy_set_header   X-Forwarded-For    $remote_addr;
          proxy_cookie_path  /                  "/; Secure";
        '';
      };
      extraConfig = ''
        allow 192.168.1.0/24;
        deny all;
      '';
    };
  };
}
