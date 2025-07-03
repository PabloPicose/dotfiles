vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*.qrc',
  callback = function()
    vim.bo.filetype = 'xml'
  end,
})
