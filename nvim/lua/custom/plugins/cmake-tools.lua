local function genKeys()
  local wk = require 'which-key'
  wk.add {
    -- { '<leader>e', '<cmd>Neotree<cr>', desc = 'Open TreeFile', mode = 'n' },
    { '<leader>cm', desc = 'CMake', mode = 'n' }, -- group
    { '<leader>cmg', '<cmd>CMakeGenerate<CR>', desc = 'Generate CMake configuration', mode = 'n' },
    { '<leader>cmb', '<cmd>CMakeBuild<CR>', desc = 'Build CMake configuration', mode = 'n' },
    { '<leader>cmr', '<cmd>CMakeRun<CR>', desc = 'Run current target', mode = 'n' },
    { '<leader>cms', '<cmd>CMakeSelectLaunchTarget<CR>', desc = 'Select launch target', mode = 'n' },
    { '<leader>cmT', '<cmd>CMakeRunTest<CR>', desc = 'Run tests', mode = 'n' },
    { '<leader>cmS', '<cmd>CMakeTargetSettings<CR>', desc = 'Show target settings', mode = 'n' },
    { '<leader>cmp', '<cmd>CMakeSelectConfigurePreset<CR>', desc = 'Select configure preset', mode = 'n' },
    { '<leader>cmd', '<cmd>CMakeDebug<CR>', desc = 'Debug target', mode = 'n' },
    { '<leader>cmt', '<cmd>CMakeStopRunner<CR>', desc = 'Stop running program', mode = 'n' },
    { '<leader>cmo', desc = '[O]pen logs', mode = 'n' }, -- group
    { '<leader>cmob', '<cmob>CMakeOpenExecutor<CR>', desc = '[B]uild logs', mode = 'n' },
    { '<leader>cmor', '<cmor>CMakeOpenExecutor<CR>', desc = '[R]unner logs', mode = 'n' },
  }
end

return {
  'Civitasv/cmake-tools.nvim',
  lazy = true,
  init = function()
    local loaded = false
    local function check()
      local cwd = vim.uv.cwd()
      if vim.fn.filereadable(cwd .. '/CMakeLists.txt') == 1 then
        require('lazy').load { plugins = { 'cmake-tools.nvim' } }
        loaded = true
        genKeys()
      end
    end
    check()
    vim.api.nvim_create_autocmd('DirChanged', {
      callback = function()
        if not loaded then
          check()
        end
      end,
    })
  end,
  opts = {
    cmake_regenerate_on_save = false,
    cmake_executor = { -- build and throw the messages to the quickfix/terminal
      name = 'quickfix',
      opts = {
        -- Quickfix can be reopen with ':copen' command
        auto_close_when_success = true, -- ← This keeps the window open
      },
    },
    cmake_runner = {
      name = 'terminal',
      -- name = 'quickfix',
      opts = {
        auto_close_when_success = false,
        focus = false,
        -- close_on_exit = false,
      },
    },
  },
}
