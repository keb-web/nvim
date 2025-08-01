return {
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
    keys = { {
      '<leader>st',
      function()
        require('snacks').picker.todo_comments()
      end,
      desc = 'Search TODO',
    } },
  },
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
      indent = { enabled = true },
      bufdelete = { enabled = true },
      notifier = { enabled = true },
      scroll = { enabled = false },
      lazygit = { enabled = true },
      zen = { enabled = true, toggles = { dim = false }, win = { backdrop = { transparent = false, blend = 99 } } },
      picker = { enabled = true },
      dashboard = { enabled = true },
    },
	-- stylua: ignore
    keys = {
      { '<leader>n', function() Snacks.notifier.show_history() end, desc = 'Notification History'},
      { '<leader>gg', function() Snacks.lazygit() end, desc = 'Lazygit',},
	  { "<leader>sf", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
	  { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
	  { "<leader>sb", function() Snacks.picker.buffers() end, desc = "Buffers" },
	  { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
	  { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
	  { "<leader>sN", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
	  { "<leader>/", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
	  { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
	  { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
	  { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
      { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
      { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
      { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
      { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
      { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
      { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
	  { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
	  { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
	  { "<leader>z", function() Snacks.zen() end, desc = "Toggle Zen Mode" },
	  { "<leader>Z", function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
		},
    -- stylua: ignore end
    init = function()
      vim.api.nvim_create_autocmd('User', {
        pattern = 'VeryLazy',
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd -- Override print to use snacks for `:=` command

          -- Create some toggle mappings
          Snacks.toggle.option('spell', { name = 'Spelling' }):map '<leader>us'
          Snacks.toggle.option('wrap', { name = 'Wrap' }):map '<leader>uw'
          Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map '<leader>uL'
          Snacks.toggle.diagnostics():map '<leader>ud'
          Snacks.toggle.treesitter():map '<leader>uT'
          Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'Dark Background' }):map '<leader>ub'
          Snacks.toggle.inlay_hints():map '<leader>uh'
        end,
      })
    end,
  },
}
