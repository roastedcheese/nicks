{ pkgs, ... }:
let
  lualine = pkgs.vimPlugins.lualine-nvim.overrideAttrs {
    dependencies = [ pkgs.vimPlugins.nvim-web-devicons ];
  };
in 
{
  programs.neovim = {
    plugins = [ lualine ];

    extraLuaConfig = ''
      require('lualine').setup({
        options = {
          theme = 'auto'
        }
      })
    '';
  };
}
