local function genKeys()
  local wk = require 'which-key'
  local gs = require 'gitsigns'
  wk.add {

    {
      '<leader>gn',
      function()
        gs.nav_hunk 'next'
      end,
      desc = 'Generate CMake configuration',
      mode = 'n',
    },
  }
end

return {
  'lewis6991/gitsigns.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  opts = {},
  keys = {
    {
      '<leader>gn',
      function()
        require('gitsigns').nav_hunk 'next'
      end,
      desc = 'Navigate to next hunk (change)',
      mode = 'n',
    },
    {
      '<leader>gN',
      function()
        require('gitsigns').nav_hunk 'prev'
      end,
      desc = 'Navigate to previous hunk (change)',
      mode = 'n',
    },
    {
      '<leader>gp',
      function()
        require('gitsigns').preview_hunk_inline()
      end,
      desc = 'Navigate to previous hunk (change)',
      mode = 'n',
    },
  },
}
