{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.opt.programs.ssh;
  user = config.opt.system.username;
  home = config.home-manager.users.${user};
in 
{
  options.opt.programs.ssh.enable = mkEnableOption "ssh config";

  config.home-manager.users.${user}.programs.ssh = mkIf cfg.enable {
    enable = true;
    matchBlocks = {
      "*".identityFile = "${home.home.homeDirectory}/.ssh/main";
      github = {
        hostname = "github.com";
        user = "git";
        identityFile = "${home.home.homeDirectory}/.ssh/github";
      };
      "roastedcheese.org" = {
        hostname = "roastedcheese.org";
        port = 4545;
        user = "nick";
      };
      "neptunus" = {
        hostname = "192.168.1.99";
        port = 4545;
        user = "nick";
      };
    };
  };
}
