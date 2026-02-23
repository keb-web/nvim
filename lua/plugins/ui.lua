return {
  {
    'Bekaboo/deadcolumn.nvim',
    config = function()
      require('deadcolumn').setup {
        blending = {
          threshold = 0.5,
          colorcode = '#000000',
          hlgroup = { 'Normal', 'bg' },
        },
        scope = 'buffer',
        modes = { 'n', 'i' },
        warning = { colorcode = '#ff5d62' },
      }
    end,
  },
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = {
      views = {
        -- Apply single borders to various views
        cmdline_popup = {
          border = {
            style = 'single',
          },
        },
        popup = {
          border = {
            style = 'single',
          },
        },
        hover = {
          border = {
            style = 'single',
          },
        },
        confirm = {
          border = {
            style = 'single',
          },
        },
        -- ... other views you want to configure
      }, -- add any options here
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      'MunifTanjim/nui.nvim',
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      'rcarriga/nvim-notify',
    },
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {},
  },
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
