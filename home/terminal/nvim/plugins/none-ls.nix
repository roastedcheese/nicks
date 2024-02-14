{ pkgs, ... }:
{
  programs.neovim = {
    plugins = [ pkgs.vimPlugins.none-ls-nvim ];

    extraPackages = builtins.attrValues {
      inherit (pkgs) statix stylua alejandra eslint_d;
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
          null_ls.builtins.diagnostics.eslint_d,
        },
      })

      vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
    '';
  };
}
