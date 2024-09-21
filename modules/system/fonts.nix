{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkOption types mkIf;
  cfg = config.opt.system.fonts;
in {
  options.opt.system.fonts.packages = mkOption {
    type = types.listOf types.path;
    default = [];
    example = [
      (pkgs.nerdfonts.override {fonts = ["Hack" "FiraCode"];})
      pkgs.inter
    ];
  };

  config.fonts.packages = mkIf (cfg.packages != []) cfg.packages;
}
