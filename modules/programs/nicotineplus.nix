{ lib, config, pkgs, inputs, ... }:
let
  inherit (lib) mkOption mkEnableOption types mkIf;
  cfg = config.opt.programs.nicotinePlus;
in 
{
  options.opt.programs.nicotinePlus = {
    enable = mkEnableOption "the nicotine-plus soulseek client";
    ports = mkOption {
      type = types.nullOr (types.listOf types.port);
      default = [ 2234 ];
      description = "Ports to open in the firewall";
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.opt.system.username}.home.packages = [ inputs.nixpkgs-stable.legacyPackages.${pkgs.system}.nicotine-plus ];

    networking.firewall.allowedTCPPorts = lib.mkIf (cfg.ports != null) cfg.ports;
  };
}
