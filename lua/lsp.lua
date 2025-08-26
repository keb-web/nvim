vim.pack.add{
  { src = 'https://github.com/neovim/nvim-lspconfig' },
  { src = 'https://github.com/mason-org/mason.nvim' },
}

require 'mason'.setup()

-- native lsp keymaps
local map = vim.keymap.set
-- map('n', 'grn', vim.lsp.buf.rename, {desc='rename'})
-- map('n', 'gra', vim.lsp.buf.code_action, {desc='code action'})
-- map('n', 'grr', vim.lsp.buf.references, {desc='references'})
-- map('n', 'gri', vim.lsp.buf.implementation, {desc='implementation'})
-- map('n', 'grt', vim.lsp.buf.type_definition, {desc='type definition'})
-- map("n", "gd", vim.lsp.buf.definition, {desc='definition'})
-- map("n", "gO", vim.lsp.buf.document_symbol, {desc='symbols'})
map("n", "<leader>ud", function()
	vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "diagnostics" })

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
					'require'
				},
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			},
			telemetry = {
				enable = false,
			},
		},
	},
})

-- config for nightly-specific issues
vim.lsp.config("pyright", {
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
  }
})

vim.lsp.enable('pyright')
vim.lsp.enable('lua_ls')

