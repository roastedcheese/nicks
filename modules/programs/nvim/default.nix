{ lib, config, pkgs, ... }:
let
  cfg = config.opt.programs.neovim;
  inherit (lib) strings mkOption mkEnableOption types mkIf;
  mkPlOption = desc: mkOption {
    type = types.bool;
    default = true;
    description = "Wheter to enable ${desc}";
  };
in 
{
  options.opt.programs.neovim = {
    enable = mkEnableOption "neovim text editor";
    noUndoFile = mkOption {
      type = types.listOf types.str;
      default = [ "/docs/*" "*.age" "*.ssh/*" "*.gnupg/*" "*/etc/ssh*" ];
      description = "filename patterns not to write undo history for";
      example = [ "*.secret" "*.age" ];
    };
    plugins = {
      alpha = mkPlOption "the alpha.nvim dashboard";
      autopairs = mkPlOption "the nvim-autopairs plugin";
      barbar = mkPlOption "the barbar plugin";
      colorizer = mkPlOption "the colorizer plugin";
      comment = mkPlOption "the comment plugin";
      completions = mkPlOption "the completions plugin";
      gitsigns = mkPlOption "the gitsigns plugin";
      lspConfig = mkPlOption "lsp support";
      lualine = mkPlOption "the lualine plugin";
      noneLs = mkPlOption "the none-ls plugin";
      nvimTree = mkPlOption "the nvim-tree plugin";
      rosePine = mkPlOption "the rose pine theme";
      telescope = mkPlOption "the telescope plugin";
     treesitter = mkPlOption "the treesitter plugin";
    };
  };

  config = mkIf cfg.enable {
    opt.programs.neovim.noUndoFile = [ "/docs/*" "*.age" "*.ssh/*" "*.gnupg/*" "*/etc/ssh*" ];
    home-manager.users.${config.opt.system.username}.programs.neovim = {
      enable = true;
      extraLuaConfig = let
        s = strings.concatMapStrings (x: "\"${x}\", ") cfg.noUndoFile;
      in ''
        local opt = vim.opt
        local au = vim.api.nvim_create_autocmd

        opt.expandtab = true
        opt.tabstop = 2
        opt.softtabstop = 2
        opt.shiftwidth = 2
        opt.number = true
        opt.undofile = true
        opt.clipboard = "unnamedplus" -- use system clipboard
        opt.termguicolors = true -- required for colorizer to work

        au({"VimLeave"}, {
          pattern = {"*"},
          command = "set guicursor= | call chansend(v:stderr, \"\\x1b[ q\")" -- some terminals don't reset the cursor after quitting vim
        })

        au({"BufWritePre"}, {
          pattern = {vim.fn.expand("~") .. ${builtins.substring 0 ((builtins.stringLength s) - 2) s}}, -- Disable saving undo history for matching files
          command = "setlocal noundofile",
        })

        vim.g.mapleader = " "
      '';
    };
  };

  imports = [ ./plugins ];
}
