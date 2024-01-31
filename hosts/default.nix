{ inputs, ... }:
let
  inherit (inputs.nixpkgs.lib) nixosSystem;
  sys = "${inputs.self}/system";
  
  inherit (import sys) desktop;
in {    
  iupiter = nixosSystem {
    specialArgs = { system = "x86_64-linux"; inherit inputs; };
    modules = desktop
    ++ [
      ./iupiter
      "${sys}/hardware/nvidia.nix"
    ];
  };
}
