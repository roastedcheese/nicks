{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.opt.programs.starship;
in {
  options.opt.programs.starship.enable = mkEnableOption "starship prompt";

  config.home-manager.users.${config.opt.system.username}.programs.starship = mkIf cfg.enable {
    enable = true;
    enableFishIntegration = mkIf config.opt.programs.fish.enable true;
    settings = {
      add_newline = false;
      line_break.disabled = true;
      cmd_duration.format = "[$duration]($style) ";
      git_branch.format = "[$symbol$branch(:$remote_branch)]($style) ";
    };
  };
}
