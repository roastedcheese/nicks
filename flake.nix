{
  description = "RoastedCheese's very basic NixOS flake";

  outputs = { self, nixpkgs, ... }@inputs: 
  let
    system = "x86_64-linux";
  in 
  {
    nixosConfigurations = {
      iupiter = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit system; inherit inputs; };
        modules = [ ./system ];
      };
    };
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    ags = {
      url = "github:Aylur/ags/";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
