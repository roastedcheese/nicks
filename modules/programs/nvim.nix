{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.opt.programs.neovim;
  inherit (lib)
    mkEnableOption
    strings
    mkIf
    types
    mkOption
    ;
in
{
  imports = [ inputs.nvf.nixosModules.default ];

  options.opt.programs.neovim = {
    enable = mkEnableOption "neovim text editor";
    noUndoFile = mkOption {
      type = types.listOf types.str;
      default = [
        "/docs/*"
        "*.age"
        "*.ssh/*"
        "*.gnupg/*"
        "*/etc/ssh*"
      ];
      description = "filename patterns not to write undo history for";
      example = [
        "*.secret"
        "*.age"
      ];
    };
  };

  config = mkIf cfg.enable {
    programs.nvf = {
      enable = true;
      settings = {
        vim = {
          extraPackages = [ pkgs.qt6.qtdeclarative ];
          options = {
            relativenumber = false;
            expandtab = true;
            tabstop = 2;
            softtabstop = 2;
            shiftwidth = 2;
            number = true;
            undofile = true;
            termguicolors = true;
          };

          globals.mapleader = " ";
          keymaps = [
            {
              key = "<leader>ff";
              mode = "n";
              silent = true;
              action = "<CMD>FzfLua files<CR>";
            }
            {
              key = "<leader>fG";
              mode = "n";
              silent = true;
              action = "<CMD>FzfLua global<CR>";
            }
            {
              key = "<leader>fr";
              mode = "n";
              silent = true;
              action = "<CMD>FzfLua resume<CR>";
            }
            {
              key = "<leader>ft";
              mode = "n";
              silent = true;
              action = "<CMD>FzfLua treesitter<CR>";
            }
            {
              key = "<leader>fg";
              mode = "n";
              silent = true;
              action = "<CMD>FzfLua live_grep<CR>";
            }
          ];

          autocmds = [
            {
              event = [ "VimLeave" ];
              command = "set guicursor= | call chansend(v:stderr, \"\\x1b[ q\")";
            }
            {
              event = [ "BufWritePre" ];
              command = "";
              pattern =
                let
                  s = strings.concatMapStrings (x: "\"${x}\", ") cfg.noUndoFile;
                in
                [ ''{vim.fn.expand("~") .. ${builtins.substring 0 ((builtins.stringLength s) - 2) s}}'' ];
            }
          ];
          maps.normal."<leader>t" = {
            action = ":term<CR>";
            desc = "open a terminal buffer";
          };
          maps.terminal."<C-n>" = {
            action = "<C-\\><C-n>";
          };
          theme = {
            enable = true;
            name = "rose-pine";
            style = "main";
          };
          enableLuaLoader = true;
          clipboard = {
            enable = true;
            providers.wl-copy.enable = true;
            registers = "unnamed";
          };

          languages = {
            enableFormat = true;
            enableTreesitter = true;
            enableDAP = true;
            enableExtraDiagnostics = true;
            go.enable = true;
            java.enable = true;
            lua.enable = true;
            nix.enable = true;
            clang.enable = true;
            python.enable = true;
            markdown.enable = true;
          };

          treesitter = {
            enable = true;
            context.enable = true;
            grammars = pkgs.vimPlugins.nvim-treesitter.allGrammars;
          };

          lsp = {
            enable = true;
            servers = {
              "*" = {
                root_markers = [ ".git" ];
                capabilities = {
                  textDocument = {
                    semanticTokens = {
                      multilineTokenSupport = true;
                    };
                  };
                };
              };
              "qmlls" = {
                filetypes = [
                  "qml"
                  "qmljs"
                ];
                cmd = [ "qmlls" ];
              };
            };
            formatOnSave = true;
            null-ls.enable = true;
            mappings = {
              nextDiagnostic = "<leader>}";
              previousDiagnostic = "<leader>{";
            };
          };
          diagnostics = {
            enable = true;
            nvim-lint.enable = true;
            config = {
              signs = true;
              underline = true;
              virtual_text.current_line = true;
            };
          };
          autocomplete.blink-cmp = {
            enable = true;
            friendly-snippets.enable = true;
          };
          debugger.nvim-dap.enable = true;

          binds.whichKey.enable = true;
          git.gitsigns.enable = true;
          fzf-lua.enable = true;

          comments.comment-nvim = {
            enable = true;
            mappings = {
              toggleCurrentLine = "<leader>//";
              toggleCurrentBlock = "<leader>b/";
              toggleOpLeaderLine = "<leader>/";
              toggleSelectedBlock = "<leader>b";
              toggleSelectedLine = "<leader>/";
            };
          };

          autopairs.nvim-autopairs.enable = true;
          dashboard.alpha.enable = true;
          pluginRC.alpha = ''
            local dashboard = require("alpha.themes.dashboard")
            dashboard.section.header.val = {
              [[                                                                       ]],
              [[                                                                       ]],
              [[                                                                       ]],
              [[                                                                       ]],
              [[                                                                     ]],
              [[       ████ ██████           █████      ██                     ]],
              [[      ███████████             █████                             ]],
              [[      █████████ ███████████████████ ███   ███████████   ]],
              [[     █████████  ███    █████████████ █████ ██████████████   ]],
              [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
              [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
              [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
              [[                                                                       ]],
              [[                                                                       ]],
              [[                                                                       ]],
            }

            require("alpha").setup(dashboard.opts)
          '';
          ui.colorizer.enable = true;

          tabline.nvimBufferline = {
            enable = true;
            setupOpts.options = {
              close_command = "Bdelete! %d";
              numbers = "none";
            };
            mappings = {
              closeCurrent = "<leader>x";
              cycleNext = "<Tab>";
              cyclePrevious = "<S-Tab>";
              moveNext = "<C-Tab>";
              movePrevious = "<C-S-Tab>";
              pick = "<leader>s";
              sortByDirectory = null;
              sortByExtension = null;
              sortById = null;
            };
          };

          filetree.nvimTree = {
            enable = true;
            mappings = {
              findFile = null;
              focus = null;
              refresh = null;
              toggle = "<leader>e";
            };
            setupOpts.sync_root_with_cwd = true;
          };
          visuals.indent-blankline.enable = true;
          statusline.lualine.enable = true;
        };
      };
    };
  };
}
