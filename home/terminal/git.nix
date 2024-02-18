{
  programs.git = {
    enable = true;
    aliases = {
      a = "add";
      co = "checkout";
      c = "commit";
      b = "branch";
      s = "switch";
      ss = "status";
      d = "diff";
    };

    delta.enable = true;
    signing = {
      key = "B31F6D32812D476A330F25CBACFA5BAF88B22D43";
      signByDefault = true;
    };

    userEmail = "cheese@roastedcheese.org";
    userName = "RoastedCheese";
    extraConfig = {
      user.defaultBranch = "main";
      push.autoSetupRemote = true;
    };
  };
}
