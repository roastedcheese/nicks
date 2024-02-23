{ pkgs, ... }:
{
  imports = [
    ./nvim
    ./git.nix
    ./starship.nix
    ./fish
  ];
  home.packages = [ pkgs.btop ];
}
