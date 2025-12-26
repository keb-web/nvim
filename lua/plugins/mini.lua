return {
  {
    -- Better Around/Inside textobjects
    --
    -- Examples:
    -- - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
    --  - ci'  - [C]hange [I]nside [']quote

    'nvim-mini/mini.ai',
    version = '*',
    opts = {},
  },
  {
    'nvim-mini/mini.files',
    opts = {
      windows = {
        preview = false,
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
    'nvim-mini/mini.icons',
    version = '*',
    config = function()
      require('mini.icons').setup {}
    end,
  },
  {
    'nvim-mini/mini.splitjoin',
    version = '*',
    config = function()
      require('mini.splitjoin').setup {}
      vim.keymap.set('n', '<leader>rs', ':lua MiniSplitjoin.toggle()<CR>', { desc = 'split/join' })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
