vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.smartindent = true
vim.expandtab = true
vim.o.relativenumber = true
vim.o.number = true
vim.o.cursorline = true
vim.o.mouse = 'a'
vim.o.undofile = true
vim.o.signcolumn = 'yes'
vim.o.inccommand = 'split'
vim.o.scrolloff = 10
vim.o.winborder = 'solid'
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

vim.api.nvim_set_hl(0, 'Normal',     { bg = 'NONE' })
vim.api.nvim_set_hl(0, 'NormalNC',   { bg = 'NONE' })
vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'NONE' })

require 'keymaps'
require 'autocmds'
require 'lazy-bootstrap'
require 'lazy-plugins'
