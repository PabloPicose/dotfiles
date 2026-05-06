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
    {
      '<leader>cmob',
      function()
        local qf_winid = vim.fn.getqflist({ winid = 0 }).winid
        if qf_winid ~= 0 then
          vim.cmd 'cclose'
        else
          vim.cmd 'CMakeOpenExecutor'
        end
      end,
      desc = 'Toggle [B]uild logs',
      mode = 'n',
    },
    {
      '<leader>cmor',
      function()
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.api.nvim_buf_get_name(buf):match '%[CMakeTools%]' then
            vim.api.nvim_win_close(win, false)
            return
          end
        end
        vim.cmd 'CMakeOpenRunner'
      end,
      desc = 'Toggle [R]unner logs',
      mode = 'n',
    },
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
        -- Quickfix can be reopen with '<leader>cmob'
        auto_close_when_success = true,
      },
    },
    cmake_runner = {
      name = 'terminal',
      opts = {
        focus = false,
        close_on_exit = true,
      },
    },
  },
}
