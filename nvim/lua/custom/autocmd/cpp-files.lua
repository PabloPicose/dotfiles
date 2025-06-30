vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'c', 'cpp', 'h' },
  callback = function()
    vim.bo.tabstop = 4 -- number of spaces a <Tab> counts for
    vim.bo.shiftwidth = 4 -- number of spaces to use for each step of (auto)indent
    vim.bo.expandtab = true -- use spaces instead of tabs
  end,
})
