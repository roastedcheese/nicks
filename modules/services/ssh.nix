{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
in {
  options.opt.services.ssh.enable = mkEnableOption "the openssh daemon";

  config = mkIf config.opt.services.ssh.enable {
    services.openssh = {
      enable = true;
      ports = [4545];
      sftpFlags = ["-f AUTHPRIV" "-l INFO"];
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        AuthenticationMethods = "publickey";
        LogLevel = "VERBOSE";
      };
    };
  };
}
