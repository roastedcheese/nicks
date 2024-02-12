{ inputs, ... }:
let
  inherit (inputs.nixpkgs.lib) nixosSystem;
  sys = "${inputs.self}/system";
  
  inherit (import sys) desktop server;
in {    
  iupiter = nixosSystem {
    specialArgs = { system = "x86_64-linux"; inherit inputs; };
    modules = desktop
    ++ [
      ./iupiter
      "${sys}/hardware/nvidia.nix"
    ];
  };
  mercurius = nixosSystem { # Email Server VPS
    specialArgs = { system = "x86_64-linux"; inherit inputs; };
    modules = server
    ++ [ ./mercurius ];
  };
}
