{ lib, pkgs, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.opt.programs.ncmpcpp;
  home = config.home-manager.users.${config.opt.system.username};
  package = (pkgs.ncmpcpp.overrideAttrs (f: p: {
    src = pkgs.fetchFromGitHub {
      owner = "ncmpcpp";
      repo = "ncmpcpp";
      rev = "dc46f7a49b5bd0fdd2b3b181ece88a3fb8482dc5";
      sha256 = "sha256-3fyW5zhJxNVFBXNcdWhXR2A0W6mG2dQ0YSeZARsCrUE=";
    };
    preConfigure = "./autogen.sh";
    nativeBuildInputs = with pkgs; [ m4 autoconf automake libtool ] ++ p.nativeBuildInputs;
  })).override { visualizerSupport = true; };
in 
{
  options.opt.programs.ncmpcpp.enable = mkEnableOption "NCurses Music Player Client (Plus Plus)";
  
  config.home-manager.users.${config.opt.system.username}.programs.ncmpcpp = mkIf cfg.enable {
    enable = true;
    package = package;

    mpdMusicDir = home.xdg.userDirs.music;

    settings = {
      ncmpcpp_directory = "${home.xdg.dataHome}/ncmpcpp";
      lyrics_directory = "${home.xdg.dataHome}/ncmpcpp/lyrics";
      media_library_primary_tag = "album_artist";

      # Window #
      # song_window_title_format = "Music"
      song_window_title_format = "{%a - }{%t}|{%f}";
      statusbar_visibility = "yes";
      header_visibility = "yes";
      titles_visibility = "no";

      # Song list #
      song_status_format= "$7%t";
      song_list_format = "  %t $R%a %l  ";
      song_columns_list_format = "(53)[white]{tr} (45)[blue]{a}";

      song_library_format = "{%a - %t}|{%f}";

      # Colors #
      main_window_color = "blue";
      current_item_prefix = "$(cyan)$r";
      current_item_suffix = "$/r$(end)";

      current_item_inactive_column_prefix = "$(blue)$r";
      current_item_inactive_column_suffix = "$/r$(end)";

      color1 = "white";
      color2 = "red";

      progressbar_look = "▂▂▂";
      progressbar_color = "black";
      progressbar_elapsed_color = "blue";
    };
  };
}
