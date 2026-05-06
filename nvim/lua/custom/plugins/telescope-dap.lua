return {
  {
    'nvim-telescope/telescope-dap.nvim',
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'mfussenegger/nvim-dap',
    },
    config = function()
      require('telescope').load_extension 'dap'
    end,
    keys = {
      { '<leader>dl', '<cmd>Telescope dap list_breakpoints<CR>', desc = '[D]AP [L]ist breakpoints' },
      { '<leader>dC', '<cmd>Telescope dap configurations<CR>',   desc = '[D]AP [C]onfigurations' },
      { '<leader>dF', '<cmd>Telescope dap frames<CR>',           desc = '[D]AP [F]rames' },
      { '<leader>dV', '<cmd>Telescope dap variables<CR>',        desc = '[D]AP [V]ariables' },
    },
  },
}
