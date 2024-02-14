{ pkgs, ... }:
{
  imports = [
    ./nvim
    ./zsh
  ];
  home.packages = [ pkgs.btop ];
}
