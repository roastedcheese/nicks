{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
in 
{
  options.opt.services.ssh.enable = mkEnableOption "the openssh daemon";

  config = mkIf config.opt.services.ssh.enable {
    services.openssh = {
      enable = true;
      hostKeys = [
          {
            path = "/etc/ssh/ssh_host_ed25519_key";
            type = "ed25519";
          }];
      ports = [ 4545 ];
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        LogLevel = "VERBOSE";
      };
    };
  };
}
