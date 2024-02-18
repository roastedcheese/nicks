{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      add_newline = true;
      line_break.disabled = true;
      cmd_duration.format = "[$duration]($style) ";
      git_branch.format = "[$symbol$branch(:$remote_branch)]($style) ";
    };
  };
}
