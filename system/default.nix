let
  desktop = [
   ./core/default.nix
   ./core/nix.nix
   ./core/security.nix
   ./services
   ./programs
   ./programs/hyprland.nix
   ./programs/fonts.nix
   ./programs/gpg
  ];
  
  laptop = desktop; # Haven't set up any laptop yet :P
in {
  inherit desktop laptop;
}
