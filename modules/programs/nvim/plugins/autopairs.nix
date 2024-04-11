{ pkgs, config, lib, ... }:
let
  cfg = config.opt.programs.neovim;
in 
{
  config.home-manager.users.${config.opt.system.username}.programs.neovim = lib.mkIf (cfg.plugins.autopairs && cfg.enable) {
    plugins = [ pkgs.vimPlugins.nvim-autopairs ];

    extraLuaConfig = ''
      require("nvim-autopairs").setup {}
    '';
  };
}
