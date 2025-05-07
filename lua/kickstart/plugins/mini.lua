return {
  {
    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
    --  - ci'  - [C]hange [I]nside [']quote

    'echasnovski/mini.ai',
    version = '*',
    opts = {},
  },
  {
    'echasnovski/mini.statusline',
    version = '*',
    -- local my_active_content = function()
    -- end,
    opts = {},
  },
  {
    'echasnovski/mini.files',
    opts = {
      windows = {
        preview = true,
        width_focus = 30,
        width_preview = 30,
      },
    },
    keys = {
      {
        '<leader>e',
        function()
          require('mini.files').open(vim.api.nvim_buf_get_name(0), true)
        end,
        desc = 'Open mini.files (Directory of Current File)',
      },
      {
        '<leader>E',
        function()
          require('mini.files').open(vim.uv.cwd(), true)
        end,
        desc = 'Open mini.files (cwd)',
      },
    },
  },
  {
    'echasnovski/mini.icons',
    version = '*',
    config = function()
      require('mini.icons').setup {}
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
