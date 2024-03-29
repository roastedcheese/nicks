# Copied from @fufexan
{ pkgs, ... }:
{
  # enable zsh autocompletion for system packages (systemd, etc)
  environment.pathsToLink = ["/share/zsh"];
  users.defaultUserShell = pkgs.zsh;

  environment.systemPackages = [ pkgs.zip pkgs.wget ];

  programs = {
    zsh = {
      enable = true;
      syntaxHighlighting = {
        enable = true;
        styles = {"alias" = "fg=magenta";};
        highlighters = ["main" "brackets" "pattern"];
      };
    };
  };
}
