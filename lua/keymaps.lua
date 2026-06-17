local map = vim.keymap.set

map('n', '<leader>L', '<cmd>Lazy<cr>',             { desc = 'Lazy Package Manager' })
map('n', '<Esc>',     '<cmd>nohlsearch<CR>')
map('n', 'U',         '<C-r>',                     { desc = 'Redo' })
map('n', '<M-Tab>',   '<C-^>',                     { desc = 'Other Buffer' })
map('n', '<leader>w', ':write<CR>',                { desc = 'Write' })
map('n', '<leader>q', ':quit<CR>',                 { desc = 'Quit' })
map('n', '<leader>Q', vim.diagnostic.setloclist,   { desc = 'Diagnostics' })

map('n', '<C-h>', '<C-w><C-h>', { desc = 'Focus left' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Focus right' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Focus down' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Focus up' })

map('n', '<leader>ub', function()
  vim.o.background = vim.o.background == 'dark' and 'light' or 'dark'
end, { desc = 'Toggle background' })

map('n', '<leader>pwd', function()
  local cwd = vim.fn.getcwd()
  vim.fn.setreg('+', cwd)
  print('CWD copied: ' .. cwd)
end, { desc = 'Copy cwd' })

map('n', '<leader>pwf', function()
  local path = vim.api.nvim_buf_get_name(0)
  vim.fn.setreg('+', path)
  print('File copied: ' .. path)
end, { desc = 'Copy file path' })
