vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  callback = function()
    vim.api.nvim_set_hl(0, 'Normal',     { bg = 'NONE' })
    vim.api.nvim_set_hl(0, 'NormalNC',   { bg = 'NONE' })
    vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'NONE' })
  end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

local function clear_cmdarea()
  vim.defer_fn(function() vim.api.nvim_echo({}, false, {}) end, 800)
end

vim.api.nvim_create_autocmd({ 'InsertLeave', 'TextChanged' }, {
  callback = function()
    if #vim.api.nvim_buf_get_name(0) ~= 0 and vim.bo.buflisted and vim.bo.buftype == '' and not vim.wo.diff then
      vim.cmd 'silent! w'
      clear_cmdarea()
    end
  end,
})
