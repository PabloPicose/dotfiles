return {
  'Badhi/nvim-treesitter-cpp-tools',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  -- Optional: Configuration
  opts = function()
    local options = {
      preview = {
        quit = '<C-n>', -- optional keymapping for quit preview
        accept = '<C-y>', -- optional keymapping for accept preview
      },
      header_extension = 'h', -- optional
      source_extension = 'cpp', -- optional
      custom_define_class_function_commands = { -- optional
        TSCppImplWrite = {
          output_handle = require('nt-cpp-tools.output_handlers').get_add_to_cpp(),
        },
        --[[
                <your impl function custom command name> = {
                    output_handle = function (str, context) 
                        -- string contains the class implementation
                        -- do whatever you want to do with it
                    end
                }
                ]]
      },
    }
    return options
  end,
  -- End configuration
  config = true,
}
