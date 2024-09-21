{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkOption types mkIf mkForce;
  cfg = config.opt.services.stubby;
in {
  options.opt.services.stubby = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Wheter to enable stubby";
    };
    servers = mkOption {
      type = types.listOf types.attrs;
      default = [
        {
          address_data = "194.242.2.2";
          tls_auth_name = "dns.mullvad.net";
        }
      ];
      description = "The DNS servers to use, see https://dnsprivacy.org/dns_privacy_daemon_-_stubby/configuring_stubby/";
    };
  };

  config = mkIf cfg.enable {
    networking.nameservers = mkForce ["127.0.0.1"];
    services.stubby = {
      enable = true;
      settings =
        pkgs.stubby.passthru.settingsExample
        // {
          round_robin_upstreams = 0;
          upstream_recursive_servers = cfg.servers;
        };
    };
  };
}
