{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.opt.programs.neovim;
in {
  config.home-manager.users.${config.opt.system.username}.programs.neovim =
    lib.mkIf (cfg.plugins.lspConfig && cfg.enable)
    {
      plugins = [pkgs.vimPlugins.nvim-lspconfig];

      extraPackages = with pkgs; [
        lua-language-server
        nodePackages.typescript-language-server
        nil
        clang-tools
        pyright
        gopls
        qt6.qtdeclarative
      ];

      # TODO: write an lsp option
      extraLuaConfig = ''
        vim.diagnostic.config({ virtual_text = true })

        local capabilities = require('cmp_nvim_lsp').default_capabilities()

        vim.lsp.config('lua_ls', {})
        vim.lsp.config('ts_ls', {})
        vim.lsp.config('nil_ls', {})
        vim.lsp.config('clangd', {})
        vim.lsp.config('pyright', {})
        vim.lsp.config('gopls', {})
        vim.lsp.config('qmlls', {})

        vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
        vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, {})
      '';
    };
}
