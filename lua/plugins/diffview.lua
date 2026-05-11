return {
   'sindrets/diffview.nvim',
   cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewFileHistory' },
   keys = {
     {
       '<leader>hd',
       function()
         if next(require('diffview.lib').views) == nil then
           vim.cmd('DiffviewOpen')
         else
           vim.cmd('DiffviewClose')
         end
       end,
       desc = 'Toggle Diffview',
     },
     {
       '<leader>gh',
       '<cmd>DiffviewFileHistory %<cr>',
       desc = 'Diffview File History',
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
         vim.cmd('DiffviewOpen ' .. base .. '...HEAD')
       end,
       desc = 'Diffview branch vs dev',
     },
   },
   opts = {},
 }
