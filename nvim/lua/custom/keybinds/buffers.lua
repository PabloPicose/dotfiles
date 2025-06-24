local function move_buf_to(direction)
  local fn = vim.fn
  local api = vim.api
  local win0 = api.nvim_get_current_win()
  local buf0 = api.nvim_get_current_buf()

  -- 1) Ensure at least two windows
  local wins = api.nvim_tabpage_list_wins(0)
  if #wins == 1 then
    vim.cmd 'vsplit'
    wins = api.nvim_tabpage_list_wins(0)
  end

  -- 2) Pick target window (leftmost or rightmost)
  local target_win, extreme = wins[1], nil
  for _, w in ipairs(wins) do
    local _, col = unpack(api.nvim_win_get_position(w))
    if not extreme then
      extreme = col
      target_win = w
    else
      if direction == 'right' and col > extreme then
        extreme, target_win = col, w
      elseif direction == 'left' and col < extreme then
        extreme, target_win = col, w
      end
    end
  end

  -- 3) Move current buffer into target
  api.nvim_win_set_buf(target_win, buf0)

  -- 4) In original window, pick another buffer or enew
  api.nvim_set_current_win(win0)
  local alt = fn.bufnr '#'
  if alt > 0 and fn.buflisted(alt) == 1 and alt ~= buf0 then
    vim.cmd('buffer ' .. alt)
  else
    -- find any other listed buffer
    local bufs = fn.getbufinfo { buflisted = true }
    local pick
    for _, b in ipairs(bufs) do
      if b.bufnr ~= buf0 then
        pick = b.bufnr
        break
      end
    end
    if pick then
      vim.cmd('buffer ' .. pick)
    else
      -- vim.cmd 'enew'
      vim.notify('No other buffer to switch to', vim.log.levels.WARN)
    end
  end

  -- 5) Finally, focus the target window
  api.nvim_set_current_win(target_win)
end

-- 2) Swap buffers between two windows
local function swap_two_windows_bufs()
  local wins = vim.api.nvim_tabpage_list_wins(0)
  if #wins ~= 2 then
    vim.notify('Buffer-swap needs exactly two windows', vim.log.levels.WARN)
    return
  end
  local w1, w2 = wins[1], wins[2]
  local b1 = vim.api.nvim_win_get_buf(w1)
  local b2 = vim.api.nvim_win_get_buf(w2)
  -- swap them
  vim.api.nvim_win_set_buf(w1, b2)
  vim.api.nvim_win_set_buf(w2, b1)
end

-- mappings:
vim.keymap.set('n', '<leader>bl', function()
  move_buf_to 'right'
end, { desc = 'Move buffer to right window' })
vim.keymap.set('n', '<leader>bh', function()
  move_buf_to 'left'
end, { desc = 'Move buffer to left window' })

vim.keymap.set('n', '<leader>bs', swap_two_windows_bufs, { desc = '[S]wap Buffers (2 wins)' })

-- Smart buffer delete that keeps the window open
vim.keymap.set('n', '<leader>bd', function()
  local cur_buf = vim.api.nvim_get_current_buf()
  local alt_buf = vim.fn.bufnr '#'

  -- Use alternate buffer if valid and listed
  if alt_buf > 0 and vim.fn.buflisted(alt_buf) == 1 then
    vim.cmd('buffer ' .. alt_buf)
  else
    vim.cmd 'enew' -- fallback to a new empty buffer
  end

  vim.cmd('bdelete ' .. cur_buf)
end, { desc = 'Smart buffer delete' })
