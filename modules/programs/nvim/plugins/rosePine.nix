{ pkgs, config, lib, ... }:
let
  cfg = config.opt.programs.neovim;
in 
{
  config.home-manager.users.${config.opt.system.username}.programs.neovim = lib.mkIf (cfg.plugins.rosePine && cfg.enable) {
    plugins = [ pkgs.vimPlugins.rose-pine ];

    extraLuaConfig = ''
      vim.cmd.colorscheme "rose-pine"
    '';
  };
}
