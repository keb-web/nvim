return {
  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    'folke/tokyonight.nvim',
    enabled = false,
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('tokyonight').setup {
        styles = {
          comments = { italic = false }, -- Disable italics in comments
        },
      }

      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      vim.cmd.colorscheme 'tokyonight-night'
    end,
  },
  {
    'olimorris/onedarkpro.nvim',
    enabled = false,
    priority = 1000,
    config = function()
      require('onedarkpro').setup {
        highlights = {
          Comment = { italic = true },
          Directory = { bold = true },
        },
      }
      -- vim.g.onedark_hide_endofbuffer = 1
      vim.g.onedark_termcolors = 256
      vim.g.onedark_terminal_italics = 1
      vim.cmd.colorscheme 'onedark'
    end,
  },
  {
    'thesimonho/kanagawa-paper.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'kanagawa-paper-ink'
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
