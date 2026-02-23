return {
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    dependencies = {
      { 'nvim-lua/plenary.nvim', branch = 'master' },
    },
    build = 'make tiktoken',
    opts = {
      model = 'gpt-5.3-codex',
      temperature = 0.1,
      window = {
        layout = 'vertical',
        width = 0.5,
      },
      auto_insert_mode = true,
      separator = '━━',
      auto_fold = true, -- Automatically folds non-assistant messages
    },
  },
}
