{ pkgs, config, lib, ... }:
let
  cfg = config.opt.programs.neovim;
  barbar = pkgs.vimPlugins.barbar-nvim.overrideAttrs {
    dependencies = with pkgs.vimPlugins; [ gitsigns-nvim nvim-web-devicons ];
  };
in 
{
  config.home-manager.users.${config.opt.system.username}.programs.neovim = lib.mkIf (cfg.plugins.barbar && cfg.enable) {
    plugins = [ barbar ];

    extraLuaConfig = ''
      vim.g.barbar_auto_setup = false

      require("barbar").setup {
        sidebar_filetypes = {
          NvimTree = true,
        },
      }

      local map = vim.keymap.set
      local opts = { noremap = true, silent = true }

      map('n', '<S-Tab>', ':BufferPrevious<CR>', opts)
      map('n', '<Tab>', ':BufferNext<CR>', opts)

      map('n', '<C-S-Tab>', ':BufferMovePrevious<CR>', opts)
      map('n', '<C-Tab>', ':BufferMoveNext<CR>', opts)

      map('n', '<leader>x', ':BufferClose<CR>', opts)
      map('n', '<leader>n', ':enew<CR>', opts)

      map('n', '<leader>s', ':BufferPick<CR>', opts)
    '';
  };
}
