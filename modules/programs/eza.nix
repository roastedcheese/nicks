{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.opt.programs.eza;
in {
  options.opt.programs.eza.enable = mkEnableOption "eza";

  config.home-manager.users.${config.opt.system.username}.programs.eza = mkIf cfg.enable {
    enable = true;
    enableFishIntegration = mkIf config.opt.programs.fish.enable true;
    icons = "auto";
    git = true;
    extraOptions = ["--group-directories-first"];
  };
}
