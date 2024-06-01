{ lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption types mkOption;
  cfg = config.opt.services.slskd;
in 
{
  options.opt.services.slskd = {
    enable = mkEnableOption "slskd";
    envFile = mkOption {
      type = types.path;
    };
    domain = mkOption {
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    services.slskd = {
      enable = true;
      openFirewall = true;
      inherit (cfg) domain;
      environmentFile = cfg.envFile;
      settings = {
        shares.directories = [ "/srv/music" ];
        directories.downloads = "/srv/musicDown";
        permissions.file.mode = "774";
      };

      nginx = {
        enableACME = true;
        forceSSL = true;
      };
    };

    security.acme = {
      defaults.email = lib.mkDefault "security@roastedcheese.org";
      acceptTerms = lib.mkDefault true;
    };
  };
}
