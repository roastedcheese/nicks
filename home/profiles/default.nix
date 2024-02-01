{ inputs, ...}:
let
  extraSpecialArgs = {inherit inputs;};
  inherit (inputs.hm.lib) homeManagerConfiguration;

  pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;

  homeImports = {
    "nick@iupiter" = [
      ../.
      ./iupiter
    ];

    server = [
      ../.
      ./server
    ];
  };
in {
  "nick_iupiter" = homeManagerConfiguration {
    modules = homeImports."nick@iupiter";
    inherit pkgs extraSpecialArgs;
  };

  server = homeManagerConfiguration {
    modules = homeImports.server;
    inherit pkgs extraSpecialArgs;
  };
}
