{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.opt.programs.neovim;
in {
  config.home-manager.users.${config.opt.system.username}.programs.neovim = lib.mkIf (cfg.plugins.treesitter && cfg.enable) {
    plugins = [pkgs.vimPlugins.nvim-treesitter.withAllGrammars];

    extraLuaConfig = ''
      require'nvim-treesitter.configs'.setup({
        highlight = { enable = true },
        indent = { enable = true },
      })
    '';
  };
}
