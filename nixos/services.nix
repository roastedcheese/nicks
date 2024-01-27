{pkgs, ...}:
{
  services = {

    automatic-timezoned.enable = true;
    printing.enable = true;
    
    pipewire = {
      enable = true;

      alsa = {
        enable = true;
        support32Bit = true;
      };

      pulse.enable = true;
      jack.enable = true;
    };

    greetd = {
      enable = true;
      settings.default_session.command = "${pkgs.greetd.greetd}/bin/agreety --cmd Hyprland";
    };
  };
}

