{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
in 
{
  options.opt.services.ssh.enable = mkEnableOption "the openssh daemon";

  config = mkIf config.opt.services.ssh.enable {
    services.openssh = {
      enable = true;
      ports = [ 4545 ];
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        LogLevel = "VERBOSE";
      };
    };
  };
}
