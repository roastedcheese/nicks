{
  description = "RoastedCheese's very basic NixOS flake";

  outputs = { self, nixpkgs, ... }@inputs: 
  {
    nixosConfigurations = import ./hosts { inherit inputs; };
    homeConfigurations = import ./home/profiles { inherit inputs; };

    lib = {
      pins = import ./npins;
    };
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

    hyprland.url = "github:hyprwm/hyprland";
    hyprcontrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
