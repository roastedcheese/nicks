{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.opt.programs.neovim;
  luasnip = pkgs.vimPlugins.luasnip.overrideAttrs {
    dependencies = with pkgs.vimPlugins; [cmp_luasnip friendly-snippets];
  };
in {
  config.home-manager.users.${config.opt.system.username}.programs.neovim = lib.mkIf (cfg.plugins.completions && cfg.enable) {
    plugins = with pkgs.vimPlugins; [
      cmp-nvim-lsp
      nvim-cmp
      luasnip
    ];

    extraLuaConfig = ''
      require("luasnip.loaders.from_vscode").lazy_load()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          -- { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
        }),
      })
    '';
  };
}
