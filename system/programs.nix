{ pkgs, ... }:
{
  programs = {
    adb.enable = true;
    hyprland.enable = true;
    zsh.enable = true;
  };
  users.defaultUserShell = pkgs.zsh;
}
