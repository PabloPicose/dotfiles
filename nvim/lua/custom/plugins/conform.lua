return { -- Autoformat
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>cf',
      function()
        require('conform').format({
          async = true,
          lsp_format = 'fallback',
        }, function(err, did_edit)
          if err then
            vim.notify('Formatting error: ' .. err, vim.log.levels.ERROR)
          elseif did_edit then
            vim.cmd 'GuessIndent'
            -- o bien: require('guess-indent').guess()
          end
        end)
      end,
      desc = '[C]ode [F]ormat buffer + GuessIndent',
      mode = { 'n', 'v' }, -- opcional: especifica modos si quieres
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      -- Disable "format_on_save lsp_fallback" for languages that don't
      -- have a well standardized coding style. You can add additional
      -- languages here or re-enable it for the disabled ones.
      local ft = vim.bo[bufnr].filetype

      -- O desactiva también para otros, si lo deseas
      local disable_lsp_for = { c = true, cpp = true, cmake = true }
      if disable_lsp_for[ft] then
        return nil
      end
      -- Instead of format the cmake with the LSP installed (neocmakelsp)
      -- uses the configured formatter in conform.nvim
      -- Currently neocmakelsp does not have formatter, so I disable this lines
      -- if ft == 'cmake' then
      --   return {
      --     timeout_ms = 500,
      --     lsp_format = false,
      --   }
      -- end

      return {
        timeout_ms = 500,
        lsp_format = 'fallback', -- usa conform si hay, y LSP si no
      }
    end,
    formatters_by_ft = {
      lua = { 'stylua' },
      json = { 'jq' },
      cpp = { 'clang_format' },
      markdown = { 'prettier' },
      cmake = { 'cmake_format' },
      -- requires executable xmllint (sudo apt install libxml2-utils)
      xml = { 'xmllint' },
      -- Conform can also run multiple formatters sequentially
      -- python = { "isort", "black" },
      --
      -- You can use 'stop_after_first' to run the first available formatter from the list
      -- javascript = { "prettierd", "prettier", stop_after_first = true },
    },
    formatters = {
      clang_format = {
        command = 'clang-format-20',
        -- puedes agregar args si quieres usar un archivo .clang-format personalizado
        -- args = { "--style=file" },
      },
    },
  },
}
