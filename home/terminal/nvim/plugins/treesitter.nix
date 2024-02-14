{ pkgs, ... }:
let
# we use withAllGrammars because with auto_install TS tries to write to nix store
  nvim-treesitter = pkgs.vimPlugins.nvim-treesitter.withAllGrammars.overrideAttrs {
    version = "v0.9.2";
    src = pkgs.fetchFromGitHub {
      owner = "nvim-treesitter";
      repo = "nvim-treesitter";
      rev = "f197a15b0d1e8d555263af20add51450e5aaa1f0";
      sha256 = "sha256-zAyiitJIgOCZTB0CmgNt0MHENM70SOHLIoWrVwOJKFg=";
    };
  };
in 
{
  programs.neovim = {
    plugins = [ nvim-treesitter ];

    extraPackages = [ pkgs.gcc ];

    extraLuaConfig = ''
      require'nvim-treesitter.configs'.setup({
        highlight = { enable = true },
        indent = { enable = true },
      })
    '';
  };
}
