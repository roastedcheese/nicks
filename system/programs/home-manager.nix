# Borrowed from @fufexan
{inputs, pkgs, ... }:
{
  imports = [
    inputs.hm.nixosModules.default
  ];
  environment.systemPackages = [
    pkgs.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };
}
