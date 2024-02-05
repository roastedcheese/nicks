{ # TODO: import func
  imports = [
    ./alpha.nix
    ./autopairs.nix
    ./barbar.nix
    ./colorizer.nix
    ./comment.nix
    ./completions.nix
    ./gitsigns.nix
    ./lsp-config.nix
    ./lualine.nix
    ./none-ls.nix
    ./nvim-tree.nix
    ./rose-pine.nix
    ./telescope.nix
    ./treesitter.nix
    ../vim.nix # This way it's at the top of init.lua
  ];
}
