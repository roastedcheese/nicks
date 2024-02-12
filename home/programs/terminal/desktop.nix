# Stuff for anything that's not a server
{ pkgs, ... }:
{
  imports = [ ./default.nix ./foot];

  home.packages = builtins.attrValues {
    inherit (pkgs) yt-dlp fscrypt-experimental gocryptfs android-file-transfer pulsemixer glow killall pulseaudio;
  };
}
