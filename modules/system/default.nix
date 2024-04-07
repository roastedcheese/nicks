{ lib, config, ... }:
let
  inherit (lib) mkOption types;
in 
{
  imports = [
    ./security.nix 
    ./nix.nix
  ];

  options.opt.system = {
    username = mkOption {
      type = types.str;
      default = "nick";
    };
  };

  config = {
    users.users.${config.opt.system.username} = {
       isNormalUser = true;
       extraGroups = [ "wheel" ]; 

    };
    ## Global unconditional stuff we're always gonna need

    networking.dhcpcd.wait = "background"; # TODO: write networking module

    # Until this isn't fixed with flakes https://github.com/NixOS/nixpkgs/issues/171054
    programs.command-not-found.enable = false;

    i18n.defaultLocale = "en_US.UTF-8";
    system.stateVersion = "23.11";
  };
}
