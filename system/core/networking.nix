{ pkgs, ... }:
{
  networking.nameservers = [ "127.0.0.1" ];
  services.stubby = {
    enable = true;
    settings = pkgs.stubby.passthru.settingsExample // {
      round_robin_upstreams = 0;
      upstream_recursive_servers = [
      {
        address_data = "194.242.2.2";
        tls_auth_name = "dns.mullvad.net";
      }
      {
        address_data = "45.90.28.0";
        tls_auth_name = "9f36d4.dns.nextdns.io";
      }
      {
        address_data = "2a07:a8c0::0";
        tls_auth_name = "9f36d4.dns.nextdns.io";
      }
      {
        address_data = "45.90.30.0";
        tls_auth_name = "9f36d4.dns.nextdns.io";
      }
      {
        address_data = "2a07:a8c1::0";
        tls_auth_name = "9f36d4.dns.nextdns.io";
      }];
    };
  };
}
