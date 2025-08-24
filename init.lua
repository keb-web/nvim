-- [[Keb's Neovim Config]] --

-- [[GLOBAL]] --
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true


-- [[OPTIONS]] --
vim.o.winborder = 'single'
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.smartindent = true  -- Like autoindent
vim.expandtab = true  -- Insert spaces when tab is pressed
vim.o.relativenumber = true  -- Relative Line Numbers
vim.o.number = true -- Line Numbers
vim.o.cursorline = true  -- Show which line your cursor is on
vim.o.mouse = 'a'  -- Enable mouse mode
vim.o.undofile = true -- Save undo history
vim.o.signcolumn = 'yes' -- Column where signs appear on left
vim.o.inccommand = 'split' -- Preview substitutions live as you type
vim.o.scrolloff = 50 -- Number of screen kept above and below the cursor
vim.o.confirm = true -- Raise a dialog to confirm file(s) save if possible fail

-- Case-insensitive searching 
-- UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true
-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true
-- Sync clipboard between OS and Neovim.
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

-- Disable default virtual text for 'tiny-inline-diagnostic.nvim'
vim.diagnostic.config { virtual_text = false }

-- [[PLUGINS]] --
vim.pack.add({
  { src = 'https://github.com/Bekaboo/deadcolumn.nvim'},
  { src = 'https://github.com/lewis6991/gitsigns.nvim' },
  { src = 'https://github.com/cohama/lexima.vim'},
  { src = 'https://github.com/kdheepak/lazygit.nvim' },
  { src = 'https://github.com/echasnovski/mini.ai' },
  { src = 'https://github.com/echasnovski/mini.files' },
  { src = 'https://github.com/echasnovski/mini.icons' },
  { src = 'https://github.com/echasnovski/mini.pick' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
  { src = 'https://github.com/kylechui/nvim-surround' },
  { src = 'https://github.com/mfussenegger/nvim-lint' },
  { src = 'https://github.com/folke/persistence.nvim'},
  { src = 'https://github.com/rachartier/tiny-inline-diagnostic.nvim' },
	{ src = 'https://github.com/vim-test/vim-test'},
  { src = 'https://github.com/christoomey/vim-tmux-navigator'},
})


require 'deadcolumn'.setup()
require 'gitsigns'.setup()
require 'mini.ai'.setup()
require 'mini.files'.setup()
require 'mini.icons'.setup()
require 'mini.pick'.setup()
require 'nvim-surround'.setup()
require 'persistence'.setup()
require 'tiny-inline-diagnostic'.setup({
  options = { multilines = {enabled = true} }
})

-- [[MAPPINGS]] --
local map = vim.keymap.set

-- general mappings
map('n', '<leader>w', ':write<CR>')
map('n', '<leader>q', ':quit<CR>')
map('n', '<C-h>', '<C-w><C-h>')
map('n', '<C-l>', '<C-w><C-l>')
map('n', '<C-j>', '<C-w><C-j>')
map('n', '<C-k>', '<C-w><C-k>')
map('n', '<M-tab>', '<cmd>e #<cr>') -- Alt-Tab
map('n', '<Esc>', '<cmd>nohlsearch<CR>') -- Clear Search

-- plugin mappings
map('n', '<leader>f', ':Pick files<CR>')
map('n', '<leader>h', ':Pick help<CR>')
map('n', '<leader>g', ':lua MiniPick.builtin.grep_live()<CR>')
map('n', '<leader>G', ':lua MiniPick.builtin.grep()<CR>')
map('n', '<leader>e', ':lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>')
map('n', '<leader>E', ':lua MiniFiles.open(vim.uv.cwd())<CR>')
map('n', '<leader>p', function() require('persistence').load() end)
map('n', '<leader>lg', '<cmd>LazyGit<CR>')
map('n', '<c-h>', ':<C-U>TmuxNavigateLeft<CR>' )
map('n', '<c-j>', ':<C-U>TmuxNavigateDown<CR>' )
map('n', '<c-k>', ':>TmuxNavigateUp<CR>' )
map('n', '<c-l>', ':<C-U>TmuxNavigateRight<CR>' )
map('n', '<leader>tn', ':TestNearest<CR>')
map('n', '<leader>tf', ':TestFile<CR>')
map('n', '<leader>ts', ':TestSuite<CR>')
map('n', '<leader>tc', ':TestClass<CR>')
map('n', '<leader>tl', ':TestLast<CR>')
map('n', '<leader>tv', ':TestVisit<CR>')

-- [[COLORSCHEME]] --
vim.pack.add({{src = 'https://github.com/neanias/everforest-nvim'}})
require 'everforest'.setup()
vim.cmd.colorscheme 'everforest'


-- [[LSP]] --
require('lsp')


-- [[COMPLETION]]
require('cmp')


-- [[LINT]] --
local lint = require('lint')
lint.linters_by_ft = {
  python = { 'flake8' }
}


-- [[AUTO COMMANDS]] --
local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'TextChanged', 'InsertLeave' }, {
  desc = 'Execute linting on specified events',
  group = lint_augroup,
  callback = function()
    -- Only run the linter in buffers that you can modify
    if vim.bo.modifiable then
      lint.try_lint()
    end
  end,
})

-- Define vertical column for python files
vim.api.nvim_create_autocmd('FileType', {
  desc = 'Add right margin ruler for python files',
  pattern = 'python',
  callback = function()
    vim.opt_local.colorcolumn = '80'
  end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  desc = 'Persist session on startup',
  group = vim.api.nvim_create_augroup("restore_session", { clear = true }),
  callback = function()
    if vim.fn.getcwd() ~= vim.env.HOME then
      require("persistence").load()
    end
  end,
  nested = true,
})

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
