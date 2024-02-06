{ inputs, pkgs, ... }:
{
  nix = {
    nixPath = [ "nixpkgs=flake:nixpkgs" ];
    registry.nixpkgs.flake = inputs.nixpkgs;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
  };
  environment.systemPackages = with pkgs; [ git npins ];
}
