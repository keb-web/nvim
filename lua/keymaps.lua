-- [[ Basic Keymaps ]]
local map = vim.keymap.set

-- Open package manager
map('n', '<leader>L', '<cmd>Lazy<cr>', { desc = '[L]azy Package Manager' })

-- Clear highlights on search when pressing <Esc> in normal mode
map('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Make U opposite to u.
map('n', 'U', '<C-r>', { desc = 'Redo' })

-- alt-tab
map('n', '<M-tab>', '<cmd>e #<cr>', { desc = 'Switch to Other Buffer' })

map('n', '<leader>w', ':write<CR>', { desc = 'write' })
map('n', '<leader>q', ':quit<CR>', { desc = 'quit' })
map('n', '<leader>Q', vim.diagnostic.setloclist, { desc = 'diagnostics' })
map('n', '<C-h>', '<C-w><C-h>')
map('n', '<C-l>', '<C-w><C-l>')
map('n', '<C-j>', '<C-w><C-j>')
map('n', '<C-k>', '<C-w><C-k>')
map('n', '<M-tab>', '<cmd>e #<cr>') -- Alt-Tab
map('n', '<Esc>', '<cmd>nohlsearch<CR>') -- Clear Search

vim.keymap.set('n', '<leader>ub', function()
  if vim.o.background == 'dark' then
    vim.o.background = 'light'
  else
    vim.o.background = 'dark'
  end
end, { desc = 'background' })

-- Easier split navigation
-- Use CRL+<hjkl> to switch between windows
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- [[ Basic Autocommands ]]

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Auto Save
local function clear_cmdarea()
  vim.defer_fn(function()
    vim.api.nvim_echo({}, false, {})
  end, 800)
end
vim.api.nvim_create_autocmd({ 'InsertLeave', 'TextChanged' }, {
  desc = 'Auto save since im tired of :wa',
  callback = function()
    if #vim.api.nvim_buf_get_name(0) ~= 0 and vim.bo.buflisted then
      vim.cmd 'silent w'
      clear_cmdarea()
    end
  end,
})

-- local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
-- vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'TextChanged', 'InsertLeave' }, {
--   desc = 'Execute linting on specified events',
--   group = lint_augroup,
--   callback = function()
--     -- Only run the linter in buffers that you can modify
--     if vim.bo.modifiable then
--       lint.try_lint()
--     end
--   end,
-- })
--

-- -- Define vertical column for python files
-- vim.api.nvim_create_autocmd('FileType', {
--   desc = 'Add right margin ruler for python files',
--   pattern = 'python',
--   callback = function()
--     vim.opt_local.colorcolumn = '80'
--   end,
-- })
