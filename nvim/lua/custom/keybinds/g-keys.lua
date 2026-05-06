vim.keymap.set('n', 'gS', function()
  vim.cmd 'rightbelow vsplit'
  vim.lsp.buf.definition()
end, { desc = 'Go to definition in vertical split' })
