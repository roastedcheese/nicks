{pkgs, ...}:
{
  imports = [
    ./pipewire.nix
  ];
  services = {
    automatic-timezoned.enable = true;
    printing.enable = true;

    greetd = {
      enable = true;
      settings.default_session.command = "${pkgs.greetd.greetd}/bin/agreety --cmd Hyprland";
    };
  };
}

