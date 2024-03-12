{ pkgs, ... }:
{
  imports = [
    ./nvim
    ./git.nix
    ./starship.nix
    ./fish
  ];
  home.packages = with pkgs; [ btop unzip ];
}
