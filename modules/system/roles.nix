{ lib, config, pkgs, ... }:
let
  inherit (lib) mkIf mkEnableOption mkDefault attrsets strings;
  cfg = config.opt.system.roles;
  mkTrue = l: lib.mkMerge (builtins.map (x: (attrsets.setAttrByPath (strings.splitString "." x) (mkDefault true))) l); # True...
  g = s: "programs.${s}.enable"; # g
in
{
  options.opt.system.roles = {
    headless = mkEnableOption "basic terminal-based software, ssh";
    workstation = mkEnableOption "full suite of software for day-to-day desktop use";
    gaming = mkEnableOption "gameing";
  };

  config.opt = lib.mkMerge [(mkIf cfg.headless (mkTrue [
    "services.ssh.enable"
    (g "nh")
    (g "fish")
    (g "git")
    (g "neovim")
    (g "eza")
    (g "starship")
    (g "ssh")
  ]))
    (mkIf cfg.workstation (mkTrue [
    "services.pipewire.enable"
    "services.pipewire.noiseTorch"
    "services.xdg.enable"
    "services.gtk.enable"
    "hardware.opengl.enable"
    (g "nh")
    (g "fish")
    (g "yt-dlp")
    (g "beets")
    (g "ssh")
    (g "starship")
    (g "git")
    (g "neovim")
    (g "eza")
    (g "firefox")
    (g "gpg")
    (g "mpv")
    (g "foot")
    (g "qbittorrent")
    (g "nicotinePlus")
    (g "hyprland")
    (g "ags")
    (g "thunderbird")
    (g "zathura")
    
  ])) (mkIf cfg.workstation {
    system.fonts.packages = [ (pkgs.nerdfonts.override { fonts = [ "Hack" "FiraCode" ]; }) ];
    home.packages = builtins.attrValues {
      inherit (pkgs)
        gimp ffmpeg rnnoise-plugin tenacity sxiv copyq libnotify keepassxc vorta borgbackup tor-browser libreoffice; # TODO: tooling module
    };
  })
    (mkIf cfg.gaming (mkTrue [
    "programs.gaming.steam"
    "programs.gaming.prism"
    "programs.gaming.heroic"
  ]))];
}
