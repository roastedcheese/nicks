{ lib, config, pkgs, ... }:
let
  inherit (lib) mkOption mkIf types mkEnableOption;
  cfg = config.opt;
  semanticConfType = with types;
    let
      confAtom = nullOr
        (oneOf [
          bool
          int
          float
          str
          path
          package
        ]) // {
        description = "Nix config atom (null, bool, int, float, str, path or package)";
      };
    in
    attrsOf (either confAtom (listOf confAtom));
in 
{
  options.opt = {
    nix = {
      nixPath = mkOption {
        type = types.listOf types.str;
        default = [ "nixpkgs=flake:nixpkgs" ];
      };
      settings = mkOption {
        type = types.submodule {
          freeformType = semanticConfType;

          options = {
            auto-optimise-store = mkOption {
              type = types.bool;
              default = true;
            };
            experimental-features = mkOption {
              type = types.listOf types.str;
              default = [ "nix-command" "flakes" ];
            };
          };
        };
        default = {};
      };
    };

    nixpkgs.config.allowUnfree = mkEnableOption "non-free packages";
  };

  config = { 
    inherit (cfg) nixpkgs nix; 
    environment.systemPackages = mkIf config.nix.enable [ pkgs.git ];
  };
}
