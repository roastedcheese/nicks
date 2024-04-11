{ pkgs, config, lib, ... }:
let
  cfg = config.opt.programs.neovim;
in 
{
  config.home-manager.users.${config.opt.system.username}.programs.neovim = lib.mkIf (cfg.plugins.colorizer && cfg.enable) {
    plugins = [ pkgs.vimPlugins.nvim-colorizer-lua ];

    extraLuaConfig = ''
      require'colorizer'.setup()
    '';
  };
}
