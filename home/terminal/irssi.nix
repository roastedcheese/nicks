{
  programs.irssi = {
    enable = true;
    aliases = {
      Q = "quit";
      SS = "query *status";
      C = "clear";
    };
    networks.bouncer = {
      nick = "RoastedCheese";
      server = {
        address = "roastedcheese.org";
        port = 6697;
        ssl = {
          enable = true;
          verify = true;
        };
      };
    };
    extraConfig = ''
      lookandfeel = {
        show_server_time = "on";
      }
    '';
  };
}
