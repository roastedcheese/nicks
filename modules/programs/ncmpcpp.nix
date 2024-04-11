{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.opt.programs.ncmpcpp;
  home = config.home-manager.users.${config.opt.system.username};
in 
{
  options.opt.programs.ncmpcpp.enable = mkEnableOption "NCurses Music Player Client (Plus Plus)";
  
  config.home-manager.users.${config.opt.system.username}.programs.ncmpcpp = mkIf cfg.enable {
    enable = true;

    mpdMusicDir = home.xdg.userDirs.music;

    settings = {
      ncmpcpp_directory = "${home.xdg.dataHome}/ncmpcpp";
      lyrics_directory = "${home.xdg.dataHome}/ncmpcpp/lyrics";
      media_library_primary_tag = "album_artist";

      # Window #
      # song_window_title_format = "Music"
      song_window_title_format = "{%a - }{%t}|{%f}";
      statusbar_visibility = "yes";
      header_visibility = "no";
      titles_visibility = "no";

      # Song list #
      song_status_format= "$7%t";
      song_list_format = "  %t $R%a %l  ";
      song_columns_list_format = "(53)[white]{tr} (45)[blue]{a}";

      song_library_format = "{{%a - %t} (%b)}|{%f}";

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
