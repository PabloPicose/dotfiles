-- Persists breakpoints to disk and restores them on BufReadPost.
-- The breakpoint toggle/condition keybinds (<leader>db / <leader>dB) are
-- defined in nvim-dap.lua using this plugin's API so saves happen automatically.
return {
  {
    'Weissle/persistent-breakpoints.nvim',
    dependencies = { 'mfussenegger/nvim-dap' },
    event = 'BufReadPost',
    opts = {
      save_dir = vim.fn.stdpath 'data' .. '/nvim_checkpoints',
      load_breakpoints_event = { 'BufReadPost' },
      perf_record = false,
    },
  },
}
