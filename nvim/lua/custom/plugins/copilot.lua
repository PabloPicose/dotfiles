return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    build = ':Copilot auth',
    event = 'BufReadPost',
    keys = {
      {
        '<C-g>',
        function()
          local suggestion = require 'copilot.suggestion'
          if suggestion.is_visible() then
            suggestion.accept()
          else
            suggestion.next()
          end
        end,
        mode = 'i',
        desc = 'Copilot trigger or accept',
      },
    },
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = false,
        hide_during_completion = true,
        keymap = {
          accept = false,
          next = '<M-]>',
          prev = '<M-[>',
        },
      },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
        lua = true,
        cpp = true,
        c = true,
      },
    },
    config = function(_, opts)
      require('copilot').setup(opts)

      -- Safe: only runs after copilot is loaded
      vim.api.nvim_create_autocmd({ 'TextChangedI' }, {
        callback = function()
          local suggestion = require 'copilot.suggestion'
          if suggestion.is_visible() then
            suggestion.dismiss()
          end
        end,
      })
    end,
  },
}
