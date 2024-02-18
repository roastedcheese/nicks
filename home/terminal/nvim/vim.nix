{
  programs.neovim = {
    extraLuaConfig = ''
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
        pattern = {vim.fn.expand("~") .. "/docs/*", "*.age", "*.ssh/*", "*.gnupg/*", "*/etc/ssh*"}, -- Disable saving undo history for matching files
        command = "setlocal noundofile",
      })

      vim.g.mapleader = " "
    '';
  };
}
