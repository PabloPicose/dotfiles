vim.api.nvim_create_autocmd('FileType', {
  pattern = 'qml',
  callback = function()
    local lspconfig = require 'lspconfig'
    local capabilities = require('blink.cmp').get_lsp_capabilities()

    local root_fn = lspconfig.util.root_pattern('.git', '*.qml')
    local root_dir = root_fn(vim.fn.expand '%:p') or vim.fn.getcwd()

    if not lspconfig.qmlls.manager then
      lspconfig.qmlls.setup {
        cmd = { 'qmlls' },
        filetypes = { 'qml' },
        root_dir = root_dir,
        capabilities = capabilities,
      }
    end

    local bufnr = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients { bufnr = bufnr }
    local already_attached = vim.tbl_contains(
      vim.tbl_map(function(c)
        return c.name
      end, clients),
      'qmlls'
    )

    if not already_attached then
      vim.lsp.start {
        name = 'qmlls',
        cmd = { 'qmlls' },
        filetypes = { 'qml' },
        root_dir = root_dir,
        capabilities = capabilities,
      }
    end
  end,
})
