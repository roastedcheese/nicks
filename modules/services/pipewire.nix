{ lib, config, pkgs, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.opt.services.pipewire;
in 
{
  options.opt.services.pipewire.enable = mkEnableOption "PipeWire sound server";

  config = mkIf cfg.enable {
    opt.home.packages = [ pkgs.pulseaudio ];
    services.pipewire = {
      enable = true;
      pulse.enable = true;
      jack.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
    };
  };
}
