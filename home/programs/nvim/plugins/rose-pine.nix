{ pkgs, ... }:
{
  programs.neovim = {
    plugins = [ pkgs.vimPlugins.rose-pine ];

    extraLuaConfig = ''
      vim.cmd.colorscheme "rose-pine"
    '';
  };
}
