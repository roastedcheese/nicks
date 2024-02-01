{
  description = "RoastedCheese's very basic NixOS flake";

  outputs = { self, nixpkgs, ... }@inputs: 
  {
    nixosConfigurations = import ./hosts { inherit inputs; };
    homeConfigurations = import ./home/profiles { inherit inputs; };
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    ags = {
      url = "github:Aylur/ags/";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hm = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
