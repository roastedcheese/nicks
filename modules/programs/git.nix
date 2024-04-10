{ lib, config, ... }:
let
  cfg = config.opt.programs.git;
  inherit (lib) mkOption mkEnableOption types mkIf;
in 
{
  options.opt.programs.git = {
    enable = mkEnableOption "the git version control software";
    user = {
      email = mkOption {
        type = types.str;
        default = "cheese@roastedcheese.org";
      };

      name = mkOption {
        type = types.str;
        default = "RoastedCheese";
      };
    };
  };

  config.home-manager.users.${config.opt.system.username}.programs.git = mkIf cfg.enable {
    enable = true;
    aliases = {
      a = "add";
      co = "checkout";
      c = "commit";
      b = "branch";
      s = "switch";
      ss = "status";
      d = "diff";
    };

    delta.enable = true;
    signing = {
      key = "B31F6D32812D476A330F25CBACFA5BAF88B22D43";
      signByDefault = true;
    };

    userEmail = cfg.user.email;
    userName = cfg.user.name;
    extraConfig = {
      user.defaultBranch = "main";
      push.autoSetupRemote = true;
    };
  };
}
