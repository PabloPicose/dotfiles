return {
  's1n7ax/nvim-window-picker',
  name = 'window-picker',
  event = 'VeryLazy',
  version = '2.*',
  config = function()
    require('window-picker').setup {
      highlights = {
        enabled = true,
        statusline = {
          focused = {
            fg = '#ffffff', -- white text
            bg = '#006400', -- darker green (DarkGreen)
            bold = true,
          },
          unfocused = {
            fg = '#cccccc',
            bg = '#013220', -- very dark green
            bold = true,
          },
        },
      },
    }
  end,
}
