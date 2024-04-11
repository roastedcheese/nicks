{ pkgs, config, lib, ... }:
let
  cfg = config.opt.programs.neovim;
in 
{
  config.home-manager.users.${config.opt.system.username}.programs.neovim = lib.mkIf (cfg.plugins.noneLs && cfg.enable) {
    plugins = [ pkgs.vimPlugins.none-ls-nvim ];

    extraPackages = builtins.attrValues {
      inherit (pkgs) statix stylua alejandra;
      inherit (pkgs.nodePackages) prettier;
    };

    extraLuaConfig = ''
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.formatting.prettier,
          null_ls.builtins.formatting.alejandra,
          null_ls.builtins.diagnostics.statix,
        },
      })

      vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
    '';
  };
}
