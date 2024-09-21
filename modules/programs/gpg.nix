{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkOption mkIf types;
in {
  options.opt.programs.gpg.enable = mkOption {
    type = types.bool;
    default = true;
    description = "Wheter to enable the gnupg agent";
  };

  config.programs.gnupg.agent = mkIf config.opt.programs.gpg.enable {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-curses;
  };
}
