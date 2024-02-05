{ pkgs, ... }:
let
  alpha-nvim = pkgs.vimPlugins.alpha-nvim.overrideAttrs {
    dependencies = [ pkgs.vimPlugins.nvim-web-devicons ];
  };
in 
{
  programs.neovim = {
    plugins =  [ alpha-nvim ];

    extraLuaConfig = ''
      local alpha = require("alpha")
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

      alpha.setup(dashboard.opts)
    '';
  };
}
