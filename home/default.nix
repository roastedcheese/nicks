{
  home = {
    username = "nick";
    homeDirectory = "/home/nick";
    stateVersion = "23.11";
  };
  
  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;
}
