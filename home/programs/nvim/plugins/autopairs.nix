{ pkgs, ... }:
{
  programs.neovim = {
    plugins = [ pkgs.vimPlugins.nvim-autopairs ];

    extraLuaConfig = ''
      require("nvim-autopairs").setup {}
    '';
  };
}
