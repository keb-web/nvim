-- [[Keb's Neovim Config]] --

-- [[GLOBAL]] --
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

-- [[OPTIONS]] --
vim.o.winborder = 'solid'
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.smartindent = true -- Like autoindent
vim.expandtab = true -- Insert spaces when tab is pressed
vim.o.relativenumber = true -- Relative Line Numbers
vim.o.number = true -- Line Numbers
vim.o.cursorline = true -- Show which line your cursor is on
vim.o.mouse = 'a' -- Enable mouse mode
vim.o.undofile = true -- Save undo history
vim.o.signcolumn = 'yes' -- Column where signs appear on left
vim.o.inccommand = 'split' -- Preview substitutions live as you type
vim.o.scrolloff = 40 -- Number of screen kept above and below the cursor vim.o.confirm = true -- Raise a dialog to confirm file(s) save if possible fail
vim.o.list = true
-- vim.opt.listchars = { space = '⋅', trail = '⋅', tab = '  ↦' }
vim.opt.listchars = {
  tab = '» ',
  trail = '·',
  nbsp = '␣',
}
vim.o.foldmethod = 'indent' -- Sets the fold method to indentation-based
vim.o.foldlevelstart = 99 -- Starts with all folds open

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

require 'keymaps'
require 'lazy-bootstrap'
require 'lazy-plugins'

-- Define your custom colors
local custom_colors = {
  red = '#F2594B',
}

local function set_flash_hl()
  vim.api.nvim_set_hl(0, 'FlashLabel', {
    fg = custom_colors.red,
    bold = true,
  })
end

-- Apply now
set_flash_hl()

-- Reapply after colorscheme changes
vim.api.nvim_create_autocmd('ColorScheme', {
  callback = set_flash_hl,
})

-- vim: ts=2 sts=2 sw=2 et
