{ pkgs, config, lib, ... }:
let
  cfg = config.opt.programs.neovim;
  nvim-tree = pkgs.vimPlugins.nvim-tree-lua.overrideAttrs {
    dependencies = [ pkgs.vimPlugins.nvim-web-devicons ];
  };
in 
{
  config.home-manager.users.${config.opt.system.username}.programs.neovim = lib.mkIf (cfg.plugins.nvimTree && cfg.enable) {
    plugins = [ nvim-tree ];

    extraLuaConfig = ''
      require("nvim-tree").setup {}
      vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { silent = true })
    '';
  };
}
