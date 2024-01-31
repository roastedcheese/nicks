{ pkgs, lib, inputs, ... }: # TODO: switch to home-manager for most of these
lib.mkMerge [
  {
    nixpkgs.config.allowUnfree = true;

    fonts.packages = with pkgs; [
      (nerdfonts.override { fonts = [ "Hack" "FiraCode" ]; })
      inter
    ];

    environment.systemPackages = with inputs; [
      ags.packages.x86_64-linux.default
    ];
  }
  {
    environment.systemPackages = with pkgs; [
     wget
     neovim
     mpd
     ncmpcpp
     firefox
     swww
     swaylock
     swayidle
     mpdris2
     libnotify
     glib
     mpv
     keepassxc
     nicotine-plus
     qbittorrent
     rose-pine-gtk-theme
     steam
     wofi
     wl-clipboard
     zsh
     copyq
     killall
     git
     pulseaudio
     playerctl
     grimblast
     prismlauncher
     lf
     ueberzugpp 
     yt-dlp
     gamescope
     btop
     obs-studio
     tor-browser
     tenacity
     vorta
     borgbackup
     cava
     fscrypt-experimental
     gimp
     rnnoise-plugin
     dolphin 
     qmk
     via
     gnumake
     p7zip
     android-file-transfer
     heroic
     pavucontrol
     qpwgraph
     sxiv
     fltk
     libreoffice
     ffmpeg
     gocryptfs
     foot
     pulsemixer
     lua-language-server
     nil
     stylua
     nodePackages_latest.prettier
     statix
     alejandra
     eslint_d
     nodePackages_latest.typescript-language-server
     gcc
     glow
     dolphin-emu
    ];
  }
]
