{ self, ... }: # arkenfox's user.js
let
  user-js = builtins.readFile (self.lib.pins."user.js".outPath + "/user.js");
in 
{
  programs.firefox.profiles.schizo.extraConfig = user-js;
  programs.firefox.profiles.logins.extraConfig = user-js;
}
