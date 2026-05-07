return {
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
      'orjangj/neotest-ctest',
    },
    ft = { 'c', 'cpp' },
    config = function()
      require('neotest').setup {
        adapters = {
          require('neotest-ctest').setup {
            build_dir = function()
              local ok, cmake = pcall(require, 'cmake-tools')
              if ok then return tostring(cmake.get_build_directory()) end
              return vim.fn.getcwd() .. '/build'
            end,
            is_test_file = function(file_path)
              local name = vim.fn.fnamemodify(file_path, ':t:r')
              local ext  = vim.fn.fnamemodify(file_path, ':e')
              if not vim.tbl_contains({ 'cpp', 'cc', 'cxx' }, ext) then return false end
              return name:match('Tests?$') ~= nil
                  or name:match('^[Tt]est') ~= nil
                  or name:match('_test$') ~= nil
            end,
            dap_adapter = 'codelldb',
          },
        },
        output      = { open_on_run = true },
        summary     = { open = 'botright vsplit | vertical resize 40' },
        output_panel = { open = 'botright split | resize 12' },
      }
    end,
    keys = {
      { '<leader>ct', desc = '[C]ode [T]ests', mode = 'n' }, -- group
      { '<leader>ctt', function() require('neotest').run.run() end,                        desc = 'Run nearest test' },
      { '<leader>ctf', function() require('neotest').run.run(vim.fn.expand '%') end,       desc = 'Run tests in [F]ile' },
      { '<leader>cta', function() require('neotest').run.run(vim.fn.getcwd()) end,          desc = 'Run [A]ll tests' },
      { '<leader>ctl', function() require('neotest').run.run_last() end,                    desc = 'Run [L]ast test again' },
      { '<leader>cts', function() require('neotest').summary.toggle() end,                  desc = 'Toggle [S]ummary panel' },
      { '<leader>cto', function() require('neotest').output.open { enter = true } end,      desc = 'Open test [O]utput' },
      { '<leader>ctO', function() require('neotest').output_panel.toggle() end,             desc = 'Toggle [O]utput panel' },
      { '<leader>ctx', function() require('neotest').run.stop() end,                        desc = 'Stop running test' },
      { '<leader>ctw', function() require('neotest').watch.toggle(vim.fn.expand '%') end,  desc = 'Toggle [W]atch (rerun on save)' },
      { '<leader>ctd', function() require('neotest').run.run { strategy = 'dap' } end,     desc = '[D]ebug nearest test' },
    },
  },
}
