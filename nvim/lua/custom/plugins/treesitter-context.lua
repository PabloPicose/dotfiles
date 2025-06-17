return {
  'nvim-treesitter/nvim-treesitter-context',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  opts = {
    enable = true,
    max_lines = 3, -- How many lines the context window can show at most
    trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded
    mode = 'cursor', -- Use cursor position (vs "topline" of window)
  },
}
