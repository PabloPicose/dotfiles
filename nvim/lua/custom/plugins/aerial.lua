return {
  'stevearc/aerial.nvim',
  event = 'LspAttach',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
    'nvim-telescope/telescope.nvim',
  },
  config = function()
    require('aerial').setup {
      backends = { 'treesitter', 'lsp' },
      layout = {
        max_width = { 40, 0.2 },
        min_width = 20,
        default_direction = 'prefer_right',
        placement = 'window',
      },
      show_guides = true,
      filter_kind = {
        'Class',
        'Constructor',
        'Enum',
        'Function',
        'Interface',
        'Module',
        'Method',
        'Struct',
        'Namespace',
      },
      -- Jump to symbol and center the view
      post_jump_cmd = 'normal! zz',
      -- Close aerial when selecting a symbol
      close_on_select = false,
      -- Navigate with { and } in any buffer where aerial is attached
      on_attach = function(bufnr)
        vim.keymap.set('n', '[s', '<cmd>AerialPrev<CR>', { buffer = bufnr, desc = 'Aerial prev symbol' })
        vim.keymap.set('n', ']s', '<cmd>AerialNext<CR>', { buffer = bufnr, desc = 'Aerial next symbol' })
      end,
    }

    -- Telescope integration
    require('telescope').load_extension 'aerial'

    local wk = require 'which-key'
    wk.add {
      {
        '<leader>to',
        '<cmd>AerialToggle!<CR>',
        desc = 'Toggle [O]utline panel',
        mode = 'n',
      },
      {
        '<leader>fo',
        '<cmd>Telescope aerial<CR>',
        desc = '[F]ind symbol [O]utline',
        mode = 'n',
      },
    }
  end,
}
