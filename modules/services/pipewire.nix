{ lib, config, ... }:
let
  inherit (lib) mkOption types mkIf;
in 
{
  options.opt.services.pipewire.enable = mkOption {
    type = types.bool;
    default = true;
  };

  config = mkIf config.opt.services.pipewire.enable {
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
