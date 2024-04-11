{ config, inputs, lib, ... }:
let
  inherit (lib) mkOption mkIf types;
  inherit (config.opt.system) username;
  cfg = config.opt.home-manager;
in 
{
  imports = [ inputs.hm.nixosModules.home-manager ];

  options.opt= {
    home.packages = mkOption {
      type = types.listOf types.package;
      default = [];
    };
    home-manager.enable = mkOption { 
      type = types.bool;
      default = true;
    };
  };

  config = mkIf cfg.enable {
    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
      backupFileExtension = "bak";
      extraSpecialArgs = { inherit inputs; };

      users.${username} = {
        programs.home-manager.enable = true;
        home = {
          inherit username;
          packages = config.opt.home.packages;
          homeDirectory = "/home/${username}";
          stateVersion = "23.11";
        };
      };
    };
  };
}
