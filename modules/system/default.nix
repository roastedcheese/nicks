{ lib, config, ... }:
let
  inherit (lib) mkOption types;
in 
{
  imports = [
    ./security.nix 
    ./fonts.nix
    ./nix.nix
    ./roles.nix
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
    services.localtimed.enable = true;
    services.geoclue2.enable = true;
    networking.timeServers = [
      "0.nixos.pool.ntp.org"
      "1.nixos.pool.ntp.org"
      "2.nixos.pool.ntp.org"
      "3.nixos.pool.ntp.org"
      "162.159.200.1"
      "93.94.88.50"
      "149.62.187.162"
      "37.247.53.178"
    ]; # TODO: use plain dns for these

    # Until this isn't fixed with flakes https://github.com/NixOS/nixpkgs/issues/171054
    programs.command-not-found.enable = false;

    i18n.defaultLocale = "en_US.UTF-8";
    system.stateVersion = "23.11";
  };
}
