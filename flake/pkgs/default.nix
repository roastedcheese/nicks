{
  perSystem = { inputs', pkgs, lib, ... }: 
  let
    pkgs2 = inputs'.nixpkgs.legacyPackages.extend (_: super: lib.packagesFromDirectoryRecursive {
      inherit (super) callPackage;
      directory = ./packages;
    });
  in {
    packages = lib.packagesFromDirectoryRecursive {
      inherit (pkgs2) callPackage;
      directory = ./packages;
    };
  };
}
