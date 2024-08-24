{ config, pkgs, lib, ... }:
let
  cfg = config.opt.programs.neovim;
in 
{
  config.home-manager.users.${config.opt.system.username}.programs.neovim = lib.mkIf cfg.plugins.indent-blankline {
    plugins = [ pkgs.vimPlugins.indent-blankline-nvim ];
    extraLuaConfig = ''
      require("ibl").setup()
    '';
  };
}
