{ pkgs, ... }:
{
  programs.mpv = {
    enable = true;
    config = {
      slang = "en";
    };
    scripts = [ pkgs.mpvScripts.mpris ];
  };
}
