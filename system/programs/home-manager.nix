# Borrowed from @fufexan
{inputs, ... }:
{
  imports = [
    inputs.hm.nixosModules.default
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPkgs = true;
  };
}
