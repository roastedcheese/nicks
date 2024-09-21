{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.opt.programs.neovim;
in {
  config.home-manager.users.${config.opt.system.username}.programs.neovim = lib.mkIf (cfg.plugins.bufferline && cfg.enable) {
    plugins = with pkgs.vimPlugins; [bufferline-nvim bufdelete-nvim];

    extraLuaConfig = ''
      require("bufferline").setup{
        highlights = {
          fill = {
            fg = 'background',
            bg = 'background',
          }
        },

        options = {
          close_command = "Bdelete! %d"
        }
      }

      local map = vim.keymap.set
      local opts = { noremap = true, silent = true }

      map('n', '<S-Tab>', ':BufferLineCyclePrev<CR>', opts)
      map('n', '<Tab>', ':BufferLineCycleNext<CR>', opts)

      map('n', '<C-S-Tab>', ':BufferLineMovePrev<CR>', opts)
      map('n', '<C-Tab>', ':BufferLineMoveNext<CR>', opts)

      map('n', '<leader>x', ':Bdelete<CR>', opts)
      map('n', '<leader>X', ':Bdelete!<CR>', opts)
      map('n', '<leader>n', ':enew<CR>', opts)

      map('n', '<leader>s', ':BufferLinePick<CR>', opts)
    '';
  };
}
