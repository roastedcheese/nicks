{ pkgs, ... }:
{
   systemd.packages = with pkgs; [
     mpdris2
   ];
   systemd.user.services.mpDris2.wantedBy = [ "default.target" ];
}
