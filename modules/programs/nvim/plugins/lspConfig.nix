{ pkgs, config, lib, ... }:
let
  cfg = config.opt.programs.neovim;
in 
{
  config.home-manager.users.${config.opt.system.username}.programs.neovim = lib.mkIf (cfg.plugins.lspConfig && cfg.enable) {
    plugins = [ pkgs.vimPlugins.nvim-lspconfig ];
    
    extraPackages = with pkgs; [
      luajitPackages.lua-lsp
      nodePackages.typescript-language-server
      nil
      ccls
    ];

    # TODO: write an lsp option
    extraLuaConfig = ''
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      local lspconfig = require("lspconfig")

      lspconfig.lua_ls.setup({ capabilities = capabilities })
      lspconfig.tsserver.setup({ capabilities = capabilities })
      lspconfig.nil_ls.setup({ capabilities = capabilities })
      lspconfig.ccls.setup({ capabilities = capabilities })

      vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
      vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, {})
    '';
  };
}
