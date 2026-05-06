-- nvim-dap-rr: record & replay debugging (requires `rr` installed)
-- Workflow: record with `rr record ./mybin`, then pick an rr config
-- from the DAP launch picker (<leader>dC). dap-rr appends its configs
-- to cpp/rust automatically.
-- Reverse-debugging keys are only active inside an rr session.
return {
  {
    'jonboh/nvim-dap-rr',
    dependencies = { 'mfussenegger/nvim-dap', 'nvim-telescope/telescope.nvim' },
    ft = { 'c', 'cpp', 'rust' },
    config = function()
      require('nvim-dap-rr').setup {
        mappings = {
          continue            = '<F9>',
          step_over           = '<F10>',
          step_into           = '<F11>',
          step_out            = '<F12>',
          reverse_continue    = '<S-F9>',
          reverse_step_over   = '<S-F10>',
          reverse_step_into   = '<S-F11>',
          reverse_step_out    = '<S-F12>',
          step_over_i         = '<F10><F10>',
          step_into_i         = '<F11><F11>',
          reverse_step_over_i = '<S-F10><S-F10>',
          reverse_step_into_i = '<S-F11><S-F11>',
        },
      }
    end,
  },
}
