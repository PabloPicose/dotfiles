vim.api.nvim_create_autocmd('FileType', {
  pattern = 'cmake',
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()

    -- Revisa si ya está activado en este buffer
    local clients = vim.lsp.get_clients { bufnr = bufnr }
    local already_attached = vim.tbl_contains(
      vim.tbl_map(function(c)
        return c.name
      end, clients),
      'neocmake'
    )

    if already_attached then
      return
    end

    -- Define root dir (git o cwd)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local root = vim.fs.find('.git', { upward = true, path = fname })[1]
    local root_dir = root and vim.fs.dirname(root) or vim.fn.getcwd()

    -- Inicia el cliente LSP de forma explícita
    vim.lsp.start {
      name = 'neocmake',
      cmd = { 'neocmakelsp', '--stdio' },
      root_dir = root_dir,
      filetypes = { 'cmake' },
    }
  end,
})
