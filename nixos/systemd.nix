{ config, lib, pkgs, ... }:
{
   systemd.packages = with pkgs; [
     mpdris2
   ];
   systemd.user.services.mpDris2.wantedBy = [ "default.target" ];

   # systemd.user.services.playerctld = {
   #   wantedBy = [ "default.target" ];
   #   description = "Keep track of media player activity";
   #
   #   serviceConfig = {
   #     Type = "oneshot";
   #     ExecStart = ''${pkgs.playerctl}/bin/playerctld daemon'';
   #   };
   # };
}
