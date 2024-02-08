# Not using this because theme is broken
{ config, self, ... }:
let
  rosePine = self.lib.pins."firefox-rose-pine".outPath + "/dist";
  userChrome = {
    source = rosePine;
    recursive = true;
  };
  f = n: v: userChrome // { target = "./.mozilla/firefox/${n}/chrome"; }; 
in {
  home.file = builtins.mapAttrs f config.programs.firefox.profiles;
}
