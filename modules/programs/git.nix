{
  lib,
  config,
  ...
}: let
  cfg = config.opt.programs.git;
  inherit
    (lib)
    mkOption
    mkEnableOption
    types
    mkIf
    ;
in {
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

      key = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "key used to sign commits";
      };
    };
  };

  config.home-manager.users.${config.opt.system.username}.programs = mkIf cfg.enable {
    git = {
      enable = true;

      signing = {
        inherit (cfg.user) key;
        signByDefault = true;
      };

      settings = {
        user = {
          inherit (cfg.user) email name;
        };
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        alias = {
          a = "add";
          co = "checkout";
          c = "commit";
          b = "branch";
          s = "switch";
          ss = "status";
          d = "diff";
          cl = "clone";
        };
      };
    };
    delta.enable = true;
  };
}
