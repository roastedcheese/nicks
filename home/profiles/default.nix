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

    "nick@apollo" = [
      ../.
      ./iupiter
    ];
  };
in {
  "nick@iupiter" = homeManagerConfiguration {
    modules = homeImports."nick@iupiter";
    inherit pkgs extraSpecialArgs;
  };

  "nick@mercurius" = homeManagerConfiguration {
    modules = homeImports."nick@mercurius";
    inherit pkgs extraSpecialArgs;
  };

  "nick@apollo" = homeManagerConfiguration {
    modules = homeImports."nick@apollo";
    inherit pkgs extraSpecialArgs;
  };
}
