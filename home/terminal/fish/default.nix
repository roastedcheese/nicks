{
  programs.starship.enableFishIntegration = true;
  programs.fish = {
    enable = true;

    shellAbbrs = {
      po = "poweroff";
      rb = "reboot";
      ka = "killall";
      g = "git";
      sctl = "systemctl";

      rebuild = "nixos-rebuild switch --use-remote-sudo --flake ~/nicks --show-trace";
      hm = "home-manager switch --flake ~/nicks -b backup";
    };

    shellAliases = {
      mv = "mv -iv";
      cp = "cp -riv";
      rm = "rm -vI";
      mkd = "mkdir -pv";
      ffmpeg = "ffmpeg -hide_banner";
      irssi = "irssi --home=$XDG_CONFIG_HOME/irssi";
      lf = "lfub";
      v = "$EDITOR";

      update = "nix flake update; npins upgrade";

      ls = "ls -hN --color=auto --group-directories-first";
      grep = "grep --color=auto";
      diff = "diff --color=auto";
    };

    shellInit = ''
      set EDITOR "nvim";
      function fish_user_key_bindings
        fish_vi_key_bindings
      end
    '';
  };
}
