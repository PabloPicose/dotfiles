local function genKeys()
  local wk = require 'which-key'
  wk.add {
    -- { '<leader>e', '<cmd>Neotree<cr>', desc = 'Open TreeFile', mode = 'n' },
    { '<leader>cm', '<cmd>CMake<CR>', desc = 'CMake', mode = 'n' },
    { '<leader>cmg', '<cmd>CMakeGenerate<CR>', desc = 'Generate CMake configuration', mode = 'n' },
    { '<leader>cmb', '<cmd>CMakeBuild<CR>', desc = 'Build CMake configuration', mode = 'n' },
    { '<leader>cmr', '<cmd>CMakeRun<CR>', desc = 'Run current target', mode = 'n' },
    { '<leader>cms', '<cmd>CMakeSelectLaunchTarget<CR>', desc = 'Select launch target', mode = 'n' },
    { '<leader>cmT', '<cmd>CMakeRunTest<CR>', desc = 'Run tests', mode = 'n' },
    { '<leader>cmS', '<cmd>CMakeTargetSettings<CR>', desc = 'Show target settings', mode = 'n' },
    { '<leader>cmp', '<cmd>CMakeSelectConfigurePreset<CR>', desc = 'Select configure preset', mode = 'n' },
    { '<leader>cmd', '<cmd>CMakeDebug<CR>', desc = 'Debug target', mode = 'n' },
    { '<leader>cmt', '<cmd>CMakeStopRunner<CR>', desc = 'Stop running program', mode = 'n' },
    { '<leader>cmc', '<cmd>CMakeStopRunner<CR>', desc = 'Stop running program', mode = 'n' },
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
  },
}
