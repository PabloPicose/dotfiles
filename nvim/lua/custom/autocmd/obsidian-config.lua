local function has_obsidian_dir(start_path)
  local found = vim.fs.find('.obsidian', {
    path = start_path,
    upward = true,
    type = 'directory',
  })
  return #found > 0
end

local function buf_dir(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == '' then
    return nil
  end
  return vim.fs.dirname(name)
end

local loaded_obsidian = false
local function load_obsidian()
  if loaded_obsidian then
    return
  end
  require('lazy').load { plugins = { 'obsidian.nvim' } }
  loaded_obsidian = true
  vim.cmd 'silent! edit' -- fuerza attach correcto en el buffer actual (para que LSP se attachee al buffer)
end

-- 1) Entra en markdown dentro de vault:
--    - pone conceallevel=2 en la ventana actual
--    - carga obsidian.nvim
vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile', 'BufEnter', 'WinEnter' }, {
  pattern = '*.md',
  callback = function(args)
    local bdir = buf_dir(args.buf)
    if not bdir or not has_obsidian_dir(bdir) then
      return
    end

    -- conceallevel es window-local → usa vim.wo
    if vim.wo.conceallevel ~= 2 then
      vim.wo.conceallevel = 2
    end

    if not loaded_obsidian then
      load_obsidian()
    end
  end,
})
