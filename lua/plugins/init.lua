-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'rachartier/tiny-inline-diagnostic.nvim',
    event = 'VeryLazy',
    priority = 1000,
    config = function()
      require('tiny-inline-diagnostic').setup {
        options = {
          multilines = {
            -- Enable multiline diagnostic messages
            enabled = true,
          },
        },
      }
      vim.diagnostic.config { virtual_text = false } -- Disable default virtual text
    end,
  },
  {
    'petertriho/nvim-scrollbar',
    config = function()
      local colors = require 'gruvbox-material.colors'
      require('scrollbar').setup {}
    end,
  },
}
