{ lib, config, ... }:
let
  inherit (lib) types mkOption mkEnableOption mkIf;
  cfg = config.opt.services.navidrome;
in 
{
  options.opt.services.navidrome = {
    enable = mkEnableOption "the Navidrome music server";
    musicDir = mkOption {
      type = types.path;
      default = "/srv/music";
    };
    domain = mkOption {
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    services.nginx = {
      enable = true;
      enableReload = true;
      virtualHosts."music.${cfg.domain}" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://localhost:4533";
        };
        locations."/.well-known/".tryFiles = "$uri $uri/ =404";
      };
    };

    security.acme = {
      defaults.email = "security@roastedcheese.org";
      acceptTerms = true;
    };

    networking.firewall.allowedTCPPorts = [ 443 80 ];
    services.navidrome = {
      enable = true;
      settings = {
        LogLevel = "DEBUG";
        Address = "localhost";
        Port = 4533;
        MusicFolder = cfg.musicDir;
        TranscodingCacheSize = "10GB";
      };
    };
  };
}
