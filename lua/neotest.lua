vim.pack.add({
  { src = 'https://github.com/nvim-neotest/nvim-nio' },
  { src = 'https://github.com/nvim-neotest/neotest-python' },
  { src = 'https://github.com/nvim-lua/plenary.nvim' },
  { src = 'https://github.com/nvim-neotest/neotest' },
  { src = 'https://github.com/antoinemadec/FixCursorHold.nvim' },
})

require "neotest".setup({
	adapters = {
		require('neotest-python')({
			runner = 'pytest',
		})
	}
})

-- local map = vim.keymap.set
-- map('n', '<leader>tt', function() require('neotest').run.run(vim.fn.expand('%')) end, { desc = 'Run file (neotest)' })
-- map('n', '<leader>tT', function() require('neotest').run.run(vim.uv.cwd()) end, { desc = 'Run All Test Files (neotest)' })
-- map('n', '<leader>ts', function() require('neotest').summary.toggle() end, { desc = 'Toggle Summary (neotest)' })
-- map('n', '<leader>to', function() require('neotest').output.open { enter = true, auto_close = true } end, { desc = 'Show Output (neotest)' })
-- map('n', '<leader>tO', function() require('neotest').output_panel.toggle() end, { desc = 'Toggle Output Panel (neotest)' })
-- map('n', '<leader>tS', function() require('neotest').run.stop() end, { desc = 'Stop (neotest)' })
