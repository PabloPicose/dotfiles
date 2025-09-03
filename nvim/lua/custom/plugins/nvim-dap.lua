--[[
 <CR>     Expand/Collapse",
 o        Open location (jump to source)",
 d        Delete breakpoint / watch",
 t        Toggle (enable/disable)",
 e        Edit value",
 r        Send to REPL",
]]
return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      {
        'theHamsta/nvim-dap-virtual-text',
        opts = {},
      },
    },
    config = function()
      local dap = require 'dap'
      dap.adapters.codelldb = {
        type = 'server',
        port = '${port}',
        executable = {
          command = 'codelldb',
          args = { '--port', '${port}' },
        },
      }

      local dapui = require 'dapui'
      dapui.setup()

      dap.listeners.after.event_initialized['dapui_config'] = function()
        -- vim.notify('DAP iniciado 🚀', vim.log.levels.INFO)
        dapui.open()
        -- disable virtual text by default
        local dapvtext = require 'nvim-dap-virtual-text'
        dapvtext.disable()
      end
      dap.listeners.before.event_terminated['dapui_config'] = function()
        -- vim.notify('DAP terminado 🛑', vim.log.levels.INFO)
        -- dapui.close()
      end
      dap.listeners.before.event_exited['dapui_config'] = function()
        -- vim.notify('DAP salió 👋', vim.log.levels.INFO)
        -- dapui.close()
      end
    end,
    keys = {
      {
        '<leader>dB',
        function()
          require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
        end,
        desc = 'Breakpoint Condition',
      },
      {
        '<leader>db',
        function()
          require('dap').toggle_breakpoint()
        end,
        desc = 'Toggle Breakpoint',
      },
      {
        '<leader>dc',
        function()
          require('dap').continue()
        end,
        desc = 'Run/Continue',
      },
      {
        '<leader>dr',
        function()
          require('dap').run_to_cursor()
        end,
        desc = 'Run to Cursor',
      },
      {
        '<leader>di',
        function()
          require('dap').step_into()
        end,
        desc = 'Step Into',
      },
      {
        '<leader>do',
        function()
          require('dap').step_over()
        end,
        desc = 'Step Over',
      },
      {
        '<leader>ds',
        function()
          local dap = require 'dap'
          dap.close()
          local dapui = require 'dapui'
          -- disable virtual text and UI
          dapui.close()
          local dapvtext = require 'nvim-dap-virtual-text'
          if dapvtext.is_enabled() then
            dapvtext.disable()
          end
        end,
        desc = '[S]top debugging',
      },
      {
        '<leader>du',
        function()
          require('dapui').toggle()
        end,
        desc = 'Toggle DAP UI',
      },
      {
        '<leader>de',
        function()
          require('dapui').eval(nil, { enter = true })
        end,
        desc = '[E]valuate Expression',
      },
      {
        '<leader>dv', -- call DapVirtualTextToggle
        '<cmd>DapVirtualTextToggle<CR>',
        desc = '[V]irtual Text Toggle',
      },
    },
  },
}
