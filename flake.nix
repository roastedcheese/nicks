{
  description = "RoastedCheese's NixOS flake";

  outputs = { self, nixpkgs, flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;
      flake = {
        nixosConfigurations = import ./hosts { inherit inputs; };

        lib.niv = import ./nix/sources.nix;
      };

      perSystem = { pkgs, config, ... }: {
        devShells.python = pkgs.mkShell { # Stuff I need to run some python scripts
          packages = let
            packaging = let # Ahah imagine if you could override a python package wouldn't that be cool
              inherit (pkgs.python311Packages) buildPythonPackage fetchPypi setuptools pyparsing six pytestCheckHook pretend wheel;
            in buildPythonPackage rec {
              pname = "packaging";
              version = "20.9";
              format = "pyproject";

              src = fetchPypi {
                inherit pname version;
                sha256 = "sha256-WzJ6wTINyGPcpy9FFOzAhvMRhnRLhKIwN0zB/Xdv6uU=";
              };

              nativeBuildInputs = [
                setuptools
              ];

              propagatedBuildInputs = [ pyparsing six wheel ];

              checkInputs = [
                pytestCheckHook
                pretend
              ];

              # Prevent circular dependency
              doCheck = false;
            };
          in 
          with pkgs; [
            python3 flac fish python311Packages.mutagen python311Packages.mechanicalsoup packaging
          ];

          # I like fish
          shellHook = ''
            fish
          '';
        };
      };
    };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    devshell.url = "github:numtide/devshell";
    systems.url = "github:nix-systems/default-linux";

    ags = {
      url = "github:Aylur/ags/";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hm = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1"; # What even is this fuf
    hyprcontrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    snm = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    rock = {
      url = "github:aciceri/rock5b-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    p2n = {
      url = "github:nix-community/poetry2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
