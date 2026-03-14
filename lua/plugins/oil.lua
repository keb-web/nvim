return {
  'stevearc/oil.nvim',
  dependencies = { 'nvim-mini/mini.icons' },
  keys = {
    {
      '<leader>e',
      function()
        require('oil').open()
      end,
      desc = 'Open Oil (Directory of Current File)',
    },
    {
      '<leader>E',
      function()
        require('oil').open(vim.uv.cwd())
      end,
      desc = 'Open Oil (cwd)',
    },
  },
  opts = {
    keymaps = {
      ['q'] = 'actions.close',
    },
    view_options = {
      show_hidden = true,
    },
  },
}
