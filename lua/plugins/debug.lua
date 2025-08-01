return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'nvim-neotest/nvim-nio',
      'williamboman/mason.nvim',
      'jay-babu/mason-nvim-dap.nvim',
      'mfussenegger/nvim-dap-python',
    },
	--stylua: ignore
    keys = {
      -- Basic debugging keymaps, feel free to change to your liking!
      {'<F5>', function() require('dap').continue() end, desc = 'Debug: Start/Continue'},
      {'<F1>', function() require('dap').step_into() end, desc = 'Debug: Step Into'},
	  {'<F2>', function() require('dap').step_over() end, desc = 'Debug: Step Over'},
	  {'<F3>', function() require('dap').step_out() end, desc = 'Debug: Step Out'},
	  {'<leader>bp', function() require('dap').toggle_breakpoint() end, desc = 'Debug: Toggle Breakpoint'},
	  {'<leader>BP', function() require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ') end, desc = 'Debug: Set Breakpoint'},
		-- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
	  {'<F7>', function() require('dapui').toggle() end, desc = 'Debug: See last session result.', },
	  { '<leader>dq', function() require('dap').terminate() end, desc = '[D]ebugger [Q]uit', },
	},
    -- stylua: ignore end
    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'
      require('mason-nvim-dap').setup {
        automatic_installation = true,
        handlers = {},
        ensure_installed = {
          'python',
        },
      }
      dapui.setup {
        icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
        controls = {
          icons = {
            pause = '⏸',
            play = '▶',
            step_into = '⏎',
            step_over = '⏭',
            step_out = '⏮',
            step_back = 'b',
            run_last = '▶▶',
            terminate = '⏹',
            disconnect = '⏏',
          },
        },
      }
      -- Change breakpoint icons
      vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
      vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
      local breakpoint_icons = vim.g.have_nerd_font
          and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
        or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
      for type, icon in pairs(breakpoint_icons) do
        local tp = 'Dap' .. type
        local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
        vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
      end

      dap.listeners.after.event_initialized['dapui_config'] = dapui.open
      dap.listeners.before.event_terminated['dapui_config'] = dapui.close
      dap.listeners.before.event_exited['dapui_config'] = dapui.close
    end,
  },
  {
    'mfussenegger/nvim-dap-python',
    ft = 'python',
    dependencies = {
      'mfussenegger/nvim-dap',
      'rcarriga/nvim-dap-ui',
    },
    keys = {
      {
        mode = 'n',
        '<leader>df',
        function()
          require('dap-python').test_method()
        end,
      },
    },
    config = function()
      -- local venv_path = vim.fn.getcwd() .. '/.venv/bin/python'
      local path = '~/.local/share/nvim/mason/packages/debugpy/venv/bin/python'
      require('dap-python').setup(path)
      -- require('dap-python').test_runner = 'pytest'
    end,
  },
}
