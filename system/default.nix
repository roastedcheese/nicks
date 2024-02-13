let
  desktop = [
   ./core
   ./services
   ./programs
   ./programs/hyprland.nix
   ./programs/fonts.nix
   ./programs/gpg.nix
   ./services/ssh.nix
  ];
  
  laptop = desktop; # Haven't set up any laptop yet :P


  server = [
    ./core
    ./core/nix.nix
    ./services/ssh.nix
    ./programs
  ];
in {
  inherit desktop laptop server;
}
