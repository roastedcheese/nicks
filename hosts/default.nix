{ inputs, ... }:
let
  inherit (inputs.nixpkgs.lib) nixosSystem;
  sys = "${inputs.self}/system";
  
  inherit (import sys) laptop desktop server;
in {    
  iupiter = nixosSystem {
    specialArgs = { system = "x86_64-linux"; inherit inputs; };
    modules = desktop
    ++ [
      ./iupiter
      "${sys}/hardware/nvidia.nix"
    ];
  };

  apollo = nixosSystem {
    specialArgs = { system = "x86_64-linux"; inherit inputs; };
    modules = laptop
    ++ [
      ./apollo
      "${sys}/hardware/nvidia.nix"
    ];
  };

  mercurius = nixosSystem { # Email Server VPS
    specialArgs = { system = "x86_64-linux"; inherit inputs; };
    modules = server
    ++ [ ./mercurius ];
  };
}
