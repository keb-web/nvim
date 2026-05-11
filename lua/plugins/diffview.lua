local function toggle_diffview(args)
  if next(require('diffview.lib').views) == nil then
    vim.cmd('DiffviewOpen' .. (args and (' ' .. args) or ''))
  else
    vim.cmd('DiffviewClose')
  end
end

return {
  'sindrets/diffview.nvim',
  cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewFileHistory' },
  keys = {
    {
      '<leader>gd',
      function() toggle_diffview() end,
      desc = 'Diffview toggle',
    },
    {
      '<leader>gf',
      function() toggle_diffview('-- %') end,
      desc = 'Diffview current file',
    },
    {
      '<leader>gh',
      '<cmd>DiffviewFileHistory %<cr>',
      desc = 'Diffview file history',
    },
    {
      '<leader>gH',
      '<cmd>DiffviewFileHistory<cr>',
      desc = 'Diffview repo history',
    },
    {
      '<leader>gb',
      function()
        local base = vim.fn.system('git rev-parse --verify --quiet origin/dev'):gsub('%s+', '')
        if base == '' then
          base = vim.fn.system('git rev-parse --verify --quiet dev'):gsub('%s+', '')
        end
        if base == '' then
          vim.notify('No dev branch found (tried origin/dev, dev)', vim.log.levels.ERROR)
          return
        end
        toggle_diffview(base .. '...HEAD')
      end,
      desc = 'Diffview branch vs dev',
    },
  },
  opts = {
    file_panel = {
      win_config = {
        position ='bottom',
        height = 15,
      },
    },
  },
}
