{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.opt.programs.neovim;
  telescope = pkgs.vimPlugins.telescope-nvim.overrideAttrs {
    dependencies = [pkgs.vimPlugins.plenary-nvim];
  };
in {
  config.home-manager.users.${config.opt.system.username}.programs.neovim = lib.mkIf (cfg.plugins.telescope && cfg.enable) {
    plugins = [telescope pkgs.vimPlugins.telescope-ui-select-nvim];

    extraLuaConfig = ''
      local builtin = require("telescope.builtin")
      vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})

      require("telescope").setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown {
            }
          }
        }
      })
      require("telescope").load_extension("ui-select")
    '';
  };
}
