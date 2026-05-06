return {
  'Kicamon/markdown-table-mode.nvim',
  ft = { 'markdown' },
  config = function()
    require('markdown-table-mode').setup {
      options = {
        insert = true,       -- auto-format when typing "|"
        insert_leave = true, -- auto-format when leaving insert mode
      },
    }
  end,
  keys = {
    {
      '<leader>tt',
      '<cmd>Mtm<CR>',
      ft = 'markdown',
      desc = '[T]oggle [T]able mode',
    },
  },
}
