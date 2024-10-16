{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.opt.programs.neovim;
in {
  config.home-manager.users.${config.opt.system.username}.programs.neovim = lib.mkIf cfg.plugins.dap {
    plugins = with pkgs.vimPlugins; [nvim-nio nvim-dap-ui lazydev-nvim nvim-dap nvim-dap-go];
    extraPackages = [pkgs.lldb pkgs.delve];

    extraLuaConfig = ''
      local dap = require("dap")
      require("dapui").setup()

      dap.adapters.lldb = {
        type = 'executable',
        command = '${pkgs.lldb}/bin/lldb-dap',
        name = 'lldb'
      }

      dap.configurations = {
        c = {
           {
             name = 'Launch',
             type = 'lldb',
             request = 'launch',
             program = function()
               local program = vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
               return program
             end,
             cwd = '$''\{workspaceFolder}',
             stopOnEntry = false,
             args = function()
                return vim.split(vim.fn.input("Enter args: ", "", 'file'), "+", { trimempty = true })
             end
           }
        }
      }
      require('dap-go').setup()


      local widgets = require('dap.ui.widgets')
      local scopes = widgets.sidebar(widgets.scopes)
      local frames = widgets.sidebar(widgets.frames)


      vim.keymap.set('n', '<F5>', function() dap.continue() end)
      vim.keymap.set('n', '<F10>', function() dap.step_over() end)
      vim.keymap.set('n', '<F11>', function() dap.step_into() end)
      vim.keymap.set('n', '<F12>', function() dap.step_out() end)
      vim.keymap.set('n', '<Leader>db', function() require('dap').toggle_breakpoint() end)
      vim.keymap.set('n', '<Leader>ds', function() scopes.toggle() end)
      vim.keymap.set('n', '<Leader>df', function() frames.toggle() end)
      vim.keymap.set('n', '<Leader>dh', function() hover() end)
      vim.keymap.set('n', '<Leader>dr', function() dap.restart() end)
      vim.keymap.set('n', '<Leader>de', function() dap.terminate() end)
      vim.keymap.set('n', '<Leader>dR', function() dap.repl.toggle() end)
    '';
  };
}
