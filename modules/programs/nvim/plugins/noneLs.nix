{ pkgs, config, lib, ... }:
let
  cfg = config.opt.programs.neovim;
in 
{
  config.home-manager.users.${config.opt.system.username}.programs.neovim = lib.mkIf (cfg.plugins.noneLs && cfg.enable) {
    plugins = [ pkgs.vimPlugins.none-ls-nvim ];

    extraPackages = builtins.attrValues {
      inherit (pkgs) yapf statix stylua alejandra clang-tools go;
      inherit (pkgs.nodePackages) prettier;
    };

    extraLuaConfig = ''
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          null_ls.builtins.diagnostics.statix,
          null_ls.builtins.code_actions.gitsigns,

          null_ls.builtins.formatting.stylua,
          null_ls.builtins.formatting.prettier,
          null_ls.builtins.formatting.alejandra,
          null_ls.builtins.formatting.clang_format.with({
            extra_args = { "-style=file" },
          }),
          null_ls.builtins.formatting.yapf,
          null_ls.builtins.formatting.gofmt,
        },
      })

      vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
    '';
  };
}
