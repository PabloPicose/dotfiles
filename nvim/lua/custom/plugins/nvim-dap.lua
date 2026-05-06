--[[
 DAP UI element keybindings (press ? inside a dapui window for quick help):
 <CR>     Expand/Collapse
 o        Open location (jump to source)
 d        Delete breakpoint / watch
 t        Toggle (enable/disable)
 e        Edit value
 r        Send to REPL
]]
return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'nvim-neotest/nvim-nio',
      {
        'theHamsta/nvim-dap-virtual-text',
        opts = {},
      },
    },
    config = function()
      local dap = require 'dap'

      -- ── Adapters ──────────────────────────────────────────────────────────
      dap.adapters.codelldb = {
        type = 'server',
        port = '${port}',
        executable = {
          command = 'codelldb',
          args = { '--port', '${port}' },
        },
      }

      -- ── C / C++ configurations ────────────────────────────────────────────
      -- cmake-tools (<leader>cmd) overrides `program` automatically with the
      -- selected CMake target; this entry acts as a manual fallback.
      dap.configurations.cpp = {
        {
          name = 'Launch (cmake-tools / manual)',
          type = 'codelldb',
          request = 'launch',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/build/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
          args = {},
        },
      }
      dap.configurations.c = dap.configurations.cpp

      -- ── Rust configuration ────────────────────────────────────────────────
      dap.configurations.rust = {
        {
          name = 'Launch file',
          type = 'codelldb',
          request = 'launch',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
        },
      }



      -- ── DAP UI layout ─────────────────────────────────────────────────────
      local dapui = require 'dapui'
      dapui.setup {
        layouts = {
          {
            -- Left sidebar: variables → breakpoints → call stack → watches
            elements = {
              { id = 'scopes',      size = 0.35 },
              { id = 'breakpoints', size = 0.20 },
              { id = 'stacks',      size = 0.30 },
              { id = 'watches',     size = 0.15 },
            },
            size = 40,
            position = 'left',
          },
          {
            -- Bottom panel: REPL + program output
            elements = {
              { id = 'repl',    size = 0.5 },
              { id = 'console', size = 0.5 },
            },
            size = 12,
            position = 'bottom',
          },
        },
        controls = {
          enabled = true,
          element = 'repl',
        },
        floating = {
          max_height = 0.9,
          max_width  = 0.5,
          border     = 'rounded',
        },
      }

      -- ── Session lifecycle ─────────────────────────────────────────────────
      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open()
        require('nvim-dap-virtual-text').enable()
      end
      dap.listeners.before.event_terminated['dapui_config'] = function()
        -- dapui.close()
      end
      dap.listeners.before.event_exited['dapui_config'] = function()
        -- dapui.close()
      end
    end,
    keys = {
      -- ── Breakpoints (persistent via persistent-breakpoints.nvim) ──────────
      {
        '<leader>db',
        function()
          require('persistent-breakpoints.api').toggle_breakpoint()
        end,
        desc = 'Toggle Breakpoint',
      },
      {
        '<leader>dB',
        function()
          require('persistent-breakpoints.api').set_conditional_breakpoint()
        end,
        desc = 'Breakpoint Condition',
      },
      -- ── Execution flow ────────────────────────────────────────────────────
      {
        '<leader>dc',
        function() require('dap').continue() end,
        desc = 'Run/Continue',
      },
      {
        '<leader>dr',
        function() require('dap').run_to_cursor() end,
        desc = 'Run to Cursor',
      },
      {
        '<leader>di',
        function() require('dap').step_into() end,
        desc = 'Step Into',
      },
      {
        '<leader>do',
        function() require('dap').step_over() end,
        desc = 'Step Over',
      },
      {
        '<leader>dO',
        function() require('dap').step_out() end,
        desc = 'Step Out',
      },
      {
        '<leader>ds',
        function()
          require('dap').close()
          require('dapui').close()
          local vt = require 'nvim-dap-virtual-text'
          if vt.is_enabled() then vt.disable() end
        end,
        desc = '[S]top debugging',
      },
      -- ── UI ────────────────────────────────────────────────────────────────
      {
        '<leader>du',
        function() require('dapui').toggle() end,
        desc = 'Toggle DAP UI',
      },
      {
        '<leader>de',
        function() require('dapui').eval(nil, { enter = true }) end,
        desc = '[E]valuate Expression',
      },
      {
        '<leader>dv',
        '<cmd>DapVirtualTextToggle<CR>',
        desc = '[V]irtual Text Toggle',
      },
    },
  },
}
