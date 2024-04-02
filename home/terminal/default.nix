{ pkgs, ... }:
{
  imports = [
    ./nvim
    ./git.nix
    ./starship.nix
    ./eza.nix
    ./fish
  ];
  home.packages = with pkgs; [ btop unzip ];
}
