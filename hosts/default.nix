{ inputs, ... }:
let
  nixosSystem = { name, arch ? "x86_64-linux" }:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = { system = arch; inherit inputs; };
      modules = [
        ./${name}
        ../modules
      ];
    };
   
in {    
  iupiter = nixosSystem { name = "iupiter"; };
  apollo = nixosSystem { name = "apollo"; };
  mercurius = nixosSystem { name = "mercurius"; };
}
