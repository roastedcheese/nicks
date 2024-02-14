{ pkgs, ... }:
let
  nvim-tree = pkgs.vimPlugins.nvim-tree-lua.overrideAttrs {
    dependencies = [ pkgs.vimPlugins.nvim-web-devicons ];
  };
in 
{
  programs.neovim = {
    plugins = [ nvim-tree ];

    extraLuaConfig = ''
      require("nvim-tree").setup {}
      vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { silent = true })
    '';
  };
}
