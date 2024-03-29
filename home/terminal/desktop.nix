# Stuff for anything that's not a server
# TODO: Better dir naming
{ pkgs, ... }:
{
  imports = [ ./default.nix ./irc/weechat.nix ./foot ];

  home.packages = builtins.attrValues {
    inherit (pkgs) yt-dlp fscrypt-experimental gocryptfs android-file-transfer pulsemixer glow killall pulseaudio;
  };
}
