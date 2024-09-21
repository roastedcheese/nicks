{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.opt.services.wireguard;
in {
  options.opt.services.wireguard.enable = mkEnableOption "wireguard";

  config = mkIf cfg.enable {
    networking = {
      firewall.allowedUDPPorts = [51820];
      wireguard.interfaces = {
        wg0 = {
          ips = ["10.66.238.248/32" "fc00:bbbb:bbbb:bb01::3:eef7/128"];
          listenPort = 51820;
          preSetup = "${pkgs.iproute2}/bin/ip netns add wg";
          postShutdown = "${pkgs.iproute2}/bin/ip netns del wg";
          interfaceNamespace = "wg";
          privateKeyFile = "/var/secrets/wireguard";

          peers = [
            {
              publicKey = "BOEOP01bcND1a0zvmOxRHPB/ObgjgPIzBJE5wbm7B0M=";
              allowedIPs = ["0.0.0.0/0" "::0/0"];
              endpoint = "103.75.11.50:51820";
              persistentKeepalive = 25;
            }
          ];
        };
      };
      dhcpcd.runHook = ''
        ${pkgs.iproute2}/bin/ip route add 103.75.11.50/32 via 192.168.1.1 dev enp34s0
      '';
    };
  };
}
