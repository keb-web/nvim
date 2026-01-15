local supported = {
  'javascript',
  'javascriptreact',
  'typescript',
  'typescriptreact',
  'json',
  'css',
  'scss',
  'html',
}

return {
  'stevearc/conform.nvim',
  -- event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>c',
      function()
        require('conform').format { async = true, lsp_format = 'never' }
      end,
      mode = '',
      desc = 'conform',
    },
  },

  opts = function(_, opts)
    -- keep existing options
    opts.notify_on_error = false
    -- format on save (no LSP for web files)

    -- formatters by filetype
    opts.formatters_by_ft = opts.formatters_by_ft or {}

    for _, ft in ipairs(supported) do
      opts.formatters_by_ft[ft] = opts.formatters_by_ft[ft] or {}
      table.insert(opts.formatters_by_ft[ft], 'prettier')
    end

    -- lua / python extras
    opts.formatters_by_ft['lua'] = { 'stylua' }
    opts.formatters_by_ft['python'] = { 'autoflake', 'black' }

    -- prettier config
    -- opts.formatters = opts.formatters or {}
    -- opts.formatters.prettier = {
    --   prepend_args = { '--tab-width', '2', '--no-use-tabs' },
    -- }
  end,
}
