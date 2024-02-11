{ pkgs, ... }:
{ # Stuff for anything that's not a server
  imports = [ ./default.nix ];

  home.packages = builtins.attrValues {
    inherit (pkgs) yt-dlp btop fscrypt-experimental gocryptfs android-file-transfer pulsemixer glow killall pulseaudio;
  };
}
