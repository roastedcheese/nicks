{ pkgs, ... }:
{
  programs.neovim = {
    plugins = [ pkgs.vimPlugins.nvim-colorizer-lua ];

    extraLuaConfig = ''
      require'colorizer'.setup()
    '';
  };
}
