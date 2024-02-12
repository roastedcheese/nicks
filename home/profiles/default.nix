{ self, inputs, ...}:
let
  extraSpecialArgs = {inherit inputs self;};
  inherit (inputs.hm.lib) homeManagerConfiguration;

  pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;

  homeImports = {
    "nick@iupiter" = [
      ../.
      ./iupiter
    ];

    "nick@mercurius" = [
      ../.
      ./mercurius
    ];
  };
in {
  "nick@iupiter" = homeManagerConfiguration {
    modules = homeImports."nick@iupiter";
    inherit pkgs extraSpecialArgs;
  };

  server = homeManagerConfiguration {
    modules = homeImports.server;
    inherit pkgs extraSpecialArgs;
  };
}
