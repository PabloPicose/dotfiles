local wk = require 'which-key'

wk.add {
  -- group
  { '<leader>t', desc = '[T]oggle', mode = 'n' }, -- group
  {
    '<leader>td',
    function()
      vim.diagnostic.enable(not vim.diagnostic.is_enabled())
    end,
    desc = 'Toggle [D]iagnostics',
    mode = 'n',
  },
}
