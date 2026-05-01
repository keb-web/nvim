return {
  'sindrets/diffview.nvim',
  cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewFileHistory' },
  keys = {
    {
      '<leader>hd',
      function()
        if next(require('diffview.lib').views) == nil then
          vim.cmd('DiffviewOpen')
        else
          vim.cmd('DiffviewClose')
        end
      end,
      desc = 'Toggle Diffview',
    },
    {
      '<leader>gh',
      '<cmd>DiffviewFileHistory %<cr>',
      desc = 'Diffview File History',
    },
  },
  opts = {},
}
