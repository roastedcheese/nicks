{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.opt.programs.neovim;
in {
  config.home-manager.users.${config.opt.system.username}.programs.neovim = lib.mkIf cfg.plugins.nvim-lint {
    plugins = [pkgs.vimPlugins.nvim-lint];
    extraPackages = [pkgs.golangci-lint];

    extraLuaConfig = ''
      local lint = require('lint')
      lint.linters_by_ft = {
        go = {'golangcilint'},
      }

      vim.api.nvim_create_autocmd({"BufWritePost"}, {
        callback = function()
          lint.try_lint()
        end
      })
      vim.keymap.set("n", "<leader>gl", lint.try_lint, {})
    '';
  };
}
