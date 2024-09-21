{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.opt.programs.neovim;
  lualine = pkgs.vimPlugins.lualine-nvim.overrideAttrs {
    dependencies = [pkgs.vimPlugins.nvim-web-devicons];
  };
in {
  config.home-manager.users.${config.opt.system.username}.programs.neovim = lib.mkIf (cfg.plugins.lualine && cfg.enable) {
    plugins = [lualine];

    extraLuaConfig = ''
      require('lualine').setup({
        options = {
          theme = 'auto'
        }
      })
    '';
  };
}
