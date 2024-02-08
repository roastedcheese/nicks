{ pkgs, ... }:
{
  xdg.desktopEntries = {
    firefox-logins = {
      name = "Firefox (logins)";
      type = "Application";
      exec = "${pkgs.firefox}/bin/firefox -P logins";
    };
    steam = {
      name = "Steam";
      type = "Application";
      exec = "${pkgs.steam}/bin/steam";
    };
  };
}
