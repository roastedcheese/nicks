{ pkgs, ... }:
{
  imports = [
    ./nvim
    ./zsh
    ./git.nix
  ];
  home.packages = [ pkgs.btop ];
}
