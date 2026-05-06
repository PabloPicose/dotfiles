return {
  'MeanderingProgrammer/render-markdown.nvim',
  ft = { 'markdown' },
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'echasnovski/mini.nvim',
  },
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {
    completions = { lsp = { enabled = true } },
  },
  keys = {
    {
      '<leader>tm',
      function()
        require('render-markdown').buf_toggle()
      end,
      ft = 'markdown',
      desc = '[T]oggle [M]arkdown render',
    },
  },
}
