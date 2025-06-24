local function show_dapui_floating_help()
  local lines = {
    'DAP UI Keybindings',
    '────────────────────────────',
    '',
    '<CR>       Expand / collapse item',
    'o          Jump to source',
    'd          Delete breakpoint / watch',
    't          Toggle enabled/disabled',
    'e          Edit value',
    'r          Send to REPL',
    'q / <Esc>  Close help',
  }

  -- 1. Create a scratch buffer
  local buf = vim.api.nvim_create_buf(false, true)

  -- 2. Set it up as a read-only, nofile buffer
  vim.bo[buf].buftype = 'nofile'
  vim.bo[buf].bufhidden = 'wipe'
  vim.bo[buf].modifiable = true -- allow us to write the lines
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false -- then make it read-only

  -- 3. Compute width/height from the longest line
  local width = 0
  for _, l in ipairs(lines) do
    width = math.max(width, vim.fn.strdisplaywidth(l))
  end
  local height = #lines

  -- 4. Open a centered floating window
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = 'minimal',
    border = 'rounded',
    noautocmd = true, -- don’t fire BufEnter/FileType/etc.
  })

  -- 5. Close on `q` or `<Esc>`
  local close_fn = function()
    vim.api.nvim_win_close(win, true)
  end
  vim.keymap.set('n', 'q', close_fn, { buffer = buf, silent = true, desc = 'Close DAP UI Help' })
  vim.keymap.set('n', '<Esc>', close_fn, { buffer = buf, silent = true, desc = 'Close DAP UI Help' })
end

-- Bind `?` only in DAP UI buffers
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'dapui_*',
  callback = function()
    vim.keymap.set('n', '?', show_dapui_floating_help, { buffer = true, desc = 'DAP UI Help' })
  end,
})

-- Bind `?` only inside DAP UI buffers
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'dapui_*',
  callback = function()
    vim.keymap.set('n', '?', show_dapui_floating_help, { buffer = true, desc = 'DAP UI Help' })
  end,
})
