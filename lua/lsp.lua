vim.pack.add {
  { src = 'https://github.com/neovim/nvim-lspconfig' },
  { src = 'https://github.com/mason-org/mason.nvim' },
  { src = 'https://github.com/williamboman/mason-lspconfig.nvim' },
  { src = 'https://github.com/stevearc/conform.nvim' },
}
local map = vim.keymap.set
map('n', '<leader>c', function()
  require('conform').format()
end, { desc = 'conform' })

require('conform').setup {
  formatters_by_ft = {
    javascript = { 'prettierd' },
    typescript = { 'prettierd' },
    javascriptreact = { 'prettierd' },
    typescriptreact = { 'prettierd', 'prettier' },
    lua = { 'stylua' },
    python = { 'black' },
    cpp = { 'clang-format' },
  },
  formatters = {
    black = {
      prepend_args = { '--line-length', '80' },
    },
  },
}

require('mason').setup()

require('mason-lspconfig').setup {
  ensure_installed = {
    'pyright',
    'lua_ls',
    'ts_ls',
    'eslint',
    'html',
    'cssls',
    'clangd',
    'marksman',
    'jsonls',
    'yamlls',
  },
}

map('n', '<leader>ud', function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = 'diagnostics' })

-- turn off lsp when working on nvim files
vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = {
          'vim',
          'require',
        },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
      },
      telemetry = {
        enable = false,
      },
    },
  },
})

-- config for nightly-specific issues
vim.lsp.config('pyright', {
  handlers = {
    -- Override the default rename handler to remove the `annotationId` from edits.
    --
    -- Pyright is being non-compliant here by returning `annotationId` in the edits, but not
    -- populating the `changeAnnotations` field in the `WorkspaceEdit`. This causes Neovim to
    -- throw an error when applying the workspace edit.
    --
    -- See:
    -- - https://github.com/neovim/neovim/issues/34731
    -- - https://github.com/microsoft/pyright/issues/10671
    [vim.lsp.protocol.Methods.textDocument_rename] = function(err, result, ctx)
      if err then
        vim.notify('Pyright rename failed: ' .. err.message, vim.log.levels.ERROR)
        return
      end

      ---@cast result lsp.WorkspaceEdit
      for _, change in ipairs(result.documentChanges or {}) do
        for _, edit in ipairs(change.edits or {}) do
          if edit.annotationId then
            edit.annotationId = nil
          end
        end
      end

      local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
      vim.lsp.util.apply_workspace_edit(result, client.offset_encoding)
    end,
  },
})

vim.lsp.config('ts_ls', {
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = 'all',
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
    javascript = {
      inlayHints = {
        includeInlayParameterNameHints = 'all',
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
  },
})

vim.lsp.enable 'pyright'
vim.lsp.enable 'lua_ls'
vim.lsp.enable 'ts_ls'
vim.lsp.enable 'eslint'
vim.lsp.enable 'html'
vim.lsp.enable 'cssls'
vim.lsp.enable 'clangd'
vim.lsp.enable 'marksman'
vim.lsp.enable 'jsonls'
vim.lsp.enable 'yamlls'
