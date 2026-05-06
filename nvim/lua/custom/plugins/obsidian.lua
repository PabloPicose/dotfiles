return {
  'obsidian-nvim/obsidian.nvim',
  version = '*',
  lazy = true,
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = {
    legacy_commands = false,
    ui = { enable = false }, -- disabled: render-markdown.nvim handles visual rendering
    link = {
      wiki = { use_name_only = true },
    },
    workspaces = {
      {
        name = 'auto',
        path = function()
          return assert(vim.fs.dirname(vim.api.nvim_buf_get_name(0)))
        end,
      },
    },
  },
}
