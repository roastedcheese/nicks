{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.opt.services.vaultwarden;
in {
  options.opt.services.vaultwarden = {
    enable = mkEnableOption "vaultwarden";
    domain = mkOption {
      type = types.str;
      example = "example.com";
    };
  };

  config = mkIf cfg.enable {
    services.vaultwarden = {
      enable = true;
      environmentFile = "/var/secrets/vaultwarden";
      config = {
        DOMAIN = "https://vault.${cfg.domain}";
        SIGNUPS_ALLOWED = false;
        ROCKET_PORT = 9999;
        ROCKET_ADDRESS = "127.0.0.1";
      };
    };

    services.nginx = {
      enable = true;
      enableReload = true;
      virtualHosts."vault.${cfg.domain}" = {
        forceSSL = true;
        useACMEHost = cfg.domain;
        locations."/" = {
          proxyPass = "http://127.0.0.1:9999";
          extraConfig = ''
            proxy_set_header X-Real-IP $remote_addr;
          '';
        };
      };
    };
  };
}
