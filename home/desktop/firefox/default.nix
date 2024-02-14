{
  imports = [ # We structure this way to let profiles override user-js
    ./modules/user-js.nix
    ./profiles.nix
    # ./modules/rose-pine.nix
  ];

  programs.firefox.enable = true;
}
