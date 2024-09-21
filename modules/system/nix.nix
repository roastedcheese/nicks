{
  lib,
  config,
  inputs,
  pkgs,
  ...
}: let
  inherit (lib) mapAttrs mkIf;
in {
  config = {
    environment.systemPackages = [pkgs.git];

    nix = let
      registry = mapAttrs (_: v: {flake = v;}) inputs;
    in {
      nixPath = ["nixpkgs=flake:nixpkgs"];
      inherit registry;

      optimise = {
        automatic = true;
        dates = ["04:00"];
      };

      settings = {
        allowed-users = ["root" "@wheel" "nix-builder"];
        trusted-users = ["root" "@wheel" "nix-builder"];

        auto-optimise-store = true;
        experimental-features = ["nix-command" "flakes"];
        use-xdg-base-directories = true;

        warn-dirty = false;
        sandbox = true;
        sandbox-fallback = false;
        builders-use-substitutes = true;

        substituters = [
          "https://cache.nixos.org"
          "https://nix-community.cachix.org"
          (mkIf config.opt.programs.hyprland.enable "https://hyprland.cachix.org")
          (mkIf config.opt.programs.ags.enable "https://ags.cachix.org")
        ];

        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          (mkIf config.opt.programs.hyprland.enable "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=")
          (mkIf config.opt.programs.ags.enable "ags.cachix.org-1:naAvMrz0CuYqeyGNyLgE010iUiuf/qx6kYrUv3NwAJ8=")
        ];
      };
    };
  };
}
