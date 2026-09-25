local icons = {
  [vim.diagnostic.severity.ERROR] = '󰅚 ',
  [vim.diagnostic.severity.WARN]  = '󰀪 ',
  [vim.diagnostic.severity.INFO]  = '󰋽 ',
  [vim.diagnostic.severity.HINT]  = '󰌶 ',
}

local virtual_text = {
  spacing = 4,
  source  = 'if_many',
  prefix  = function(diagnostic) return icons[diagnostic.severity] or '● ' end,
}

local M = { enabled = true }
local shown = nil

-- Inline text is drawn only in normal mode.
function M.apply()
  local want = M.enabled and vim.startswith(vim.api.nvim_get_mode().mode, 'n')
  if want == shown then return end
  shown = want
  vim.diagnostic.config { virtual_text = want and virtual_text or false }
end

function M.toggle()
  M.enabled = not M.enabled
  M.apply()
  vim.notify('Inline diagnostics ' .. (M.enabled and 'on' or 'off'))
end

M.apply()

return M
