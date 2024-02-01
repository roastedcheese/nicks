let
  desktop = [
   ./core/default.nix
   ./core/nix.nix
   ./core/security.nix
   ./packages.nix
   ./services
   ./programs
   ./programs/hyprland.nix
  ];
  
  laptop = desktop; # Haven't set up any laptop yet :P
in {
  inherit desktop laptop;
}
