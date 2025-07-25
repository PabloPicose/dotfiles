vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'c', 'cpp', 'lua' },
  callback = function()
    -- Quita las opciones:
    --   c: auto-wrap de comentarios usando textwidth
    --   r: continuar comentario al pulsar Enter en modo normal
    --   o: continuar comentario al usar o/O en modo normal
    vim.opt_local.formatoptions:remove { 'c', 'r', 'o' }
  end,
})
