vim.api.nvim_create_autocmd('FileType', {
  pattern = 'json',
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
    vim.bo.expandtab = true
  end,
})
