return {
  -- {
  --   'neanias/everforest-nvim',
  --   version = false,
  --   lazy = false,
  --   priority = 1000, -- make sure to load this before all the other start plugins
  --   -- Optional; default configuration will be used if setup isn't called.
  --   config = function()
  --     require('everforest').setup {
  --       -- Your config here
  --       background = 'soft'
  --     }
  --     vim.cmd.colorscheme 'everforest'
  --   end,
  -- },
  {
    'thesimonho/kanagawa-paper.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      -- vim.cmd.colorscheme 'kanagawa-paper-ink'
    end,
  },{ "catppuccin/nvim", name = "catppuccin", priority = 1000 , config = function ()
    vim.cmd.colorscheme 'catppuccin'
  end}
}
-- vim: ts=2 sts=2 sw=2 et
