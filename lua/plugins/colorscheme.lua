return {
  'f4z3r/gruvbox-material.nvim',
  lazy = false,
  config = function()
    require('gruvbox-material').setup {
      background = { light = 'light', dark = 'dark' },
      contrast = 'soft',
    }
    vim.cmd.colorscheme 'gruvbox-material'
    vim.keymap.set('n', '<leader>ub', function()
      if vim.o.background == 'dark' then
        vim.o.background = 'light'
      else
        vim.o.background = 'dark'
      end
    end, { desc = 'background' })
  end,
}
-- vim: ts=2 sts=2 sw=2 et
