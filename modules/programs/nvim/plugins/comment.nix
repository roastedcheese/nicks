{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.opt.programs.neovim;
in {
  config.home-manager.users.${config.opt.system.username}.programs.neovim = lib.mkIf (cfg.plugins.comment && cfg.enable) {
    plugins = [pkgs.vimPlugins.comment-nvim];

    extraLuaConfig = ''
      require("Comment").setup({
        toggler = {
            ---Line-comment toggle keymap
            line = '<leader>//',
            ---Block-comment toggle keymap
            block = '<leader>b/',
        },
        ---LHS of operator-pending mappings in NORMAL and VISUAL mode
        opleader = {
            ---Line-comment keymap
            line = '<leader>/',
            ---Block-comment keymap
            block = '<leader>b',
        },
        ---LHS of extra mappings
        extra = {
            ---Add comment on the line above
            above = '<leader>/O',
            ---Add comment on the line below
            below = '<leader>/o',
            ---Add comment at the end of line
            eol = '<leader>/A',
        },
      })
    '';
  };
}
