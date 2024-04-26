{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.opt.programs.fish;
  home = config.home-manager.users.${config.opt.system.username};
in 
{
  options.opt.programs.fish.enable = mkEnableOption "fish shell";

  config = mkIf cfg.enable {
    programs.fish.enable = true;
    users.defaultUserShell = pkgs.fish;
    environment.systemPackages = [ pkgs.zip pkgs.wget ];

    home-manager.users.${config.opt.system.username}.programs = {
      ripgrep.enable = true;
      fish = {
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
          adb = "HOME=${home.xdg.dataHome}/android adb";


          update = "nix flake update; niv update";

          grep = "grep --color=auto";
          diff = "diff --color=auto";
        };

        shellInit = ''
          set EDITOR "nvim"
          set -U fish_greeting
          set -U fish_cursor_insert line blink

          function fish_user_key_bindings
            fish_vi_key_bindings
          end

          # Starship's newline is stupid
          function newline --on-event fish_postexec
            echo
          end

          # env vars
          export ANDROID_USER_HOME=${home.xdg.dataHome}/android
          export HISTFILE=${home.xdg.stateHome}/bash/history
          export CUDA_CACHE_PATH=${home.xdg.cacheHome}/nv
          export FCEUX_HOME=${home.xdg.configHome}/fceux
          export GNUPGHOME=${home.xdg.dataHome}/gnupg

        '';
      };
    };
  };
}
