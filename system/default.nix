let
  desktop = [
   ./core/default.nix
   ./core/nix.nix
   ./core/programs.nix
   ./core/security.nix
   ./packages.nix
   ./services/pipewire.nix
   ./services/default.nix
   ./services/systemd.nix
  ];
  
  laptop = desktop; # Haven't set up any laptop yet :P
in {
  inherit desktop laptop;
}
