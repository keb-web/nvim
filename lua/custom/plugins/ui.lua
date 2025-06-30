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
      -- add any options here
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
}
