{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      line_break.disabled = true;
      cmd_duration.format = "[$duration]($style) ";
      git_branch.format = "[$symbol$branch(:$remote_branch)]($style) ";
    };
  };
}
