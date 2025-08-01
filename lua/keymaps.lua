-- [[ Basic Keymaps ]]

-- Open package manager
vim.keymap.set('n', '<leader>L', '<cmd>Lazy<cr>', { desc = '[L]azy Package Manager' })

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Make U opposite to u.
vim.keymap.set('n', 'U', '<C-r>', { desc = 'Redo' })

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- alt-tab
vim.keymap.set('n', '<M-tab>', '<cmd>e #<cr>', { desc = 'Switch to Other Buffer' })

-- Terminals
-- vim.keymap.set('n', '<C-;>', '<cmd>lua Snacks.terminal.toggle()<cr>', { desc = '[t]oggle [t]erminal' })


-- Exit terminal mode in the builtin terminal with a shortcut 
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

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

-- vim.api.nvim_create_autocmd('VimEnter', {
--   desc = 'Load Session when entering nvim',
--   group = vim.api.nvim_create_augroup('restore_session', { clear = true }),
--   callback = function()
--     if vim.fn.getcwd() ~= vim.env.HOME then
--       require('persistence').load()
--     end
--   end,
--   nested = true,
-- })
--

-- Define vertical column for python files
vim.api.nvim_create_autocmd('FileType', {
  desc = 'Add right margin ruler for python files',
  pattern = 'python',
  callback = function()
    vim.opt_local.colorcolumn = '80'
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

-- vim: ts=2 sts=2 sw=2 et
