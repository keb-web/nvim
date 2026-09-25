-- Diff range from the current branch back to its base branch
local function git_base_range()
  local base
  for _, ref in ipairs { 'origin/dev', 'dev', 'origin/main', 'main', 'origin/master', 'master' } do
    if vim.fn.system { 'git', 'rev-parse', '--verify', '--quiet', ref } ~= '' then
      base = ref
      break
    end
  end
  if not base then return 'HEAD' end
  -- Three-dot (merge-base) diff, or two-dot when the histories are unrelated
  vim.fn.system { 'git', 'merge-base', base, 'HEAD' }
  return base .. (vim.v.shell_error == 0 and '...' or '..') .. 'HEAD'
end

require('lazy').setup {

  -- ── Editing ────────────────────────────────────────────────────────────
  'NMAC427/guess-indent.nvim',
  { 'nvim-mini/mini.ai',        version = '*', opts = {} },
  { 'windwp/nvim-autopairs',    event = 'InsertEnter', opts = {} },

  {
    'nvim-mini/mini.files',
    opts = { windows = { preview = false, width_focus = 30 } },
    keys = {
      { '<leader>e', function() require('mini.files').open(vim.api.nvim_buf_get_name(0), true) end, desc = 'Files (current)' },
      { '<leader>E', function() require('mini.files').open(vim.uv.cwd(), true) end,                 desc = 'Files (cwd)' },
    },
  },

  { 'nvim-mini/mini.icons', config = function() require('mini.icons').setup {} end },

  {
    'nvim-mini/mini.splitjoin',
    config = function()
      require('mini.splitjoin').setup {}
      vim.keymap.set('n', '<leader>rs', MiniSplitjoin.toggle, { desc = 'Split/join' })
    end,
  },

  -- ── Markdown ───────────────────────────────────────────────────────────
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft   = { 'markdown' },
    opts = {},
    keys = {
      { '<leader>tm', '<cmd>RenderMarkdown toggle<cr>', ft = 'markdown', desc = 'Toggle markdown render' },
    },
  },

  {
    'iamcco/markdown-preview.nvim',
    ft    = { 'markdown' },
    build = 'cd app && npm install',
    keys  = {
      { '<leader>tp', '<cmd>MarkdownPreviewToggle<cr>', ft = 'markdown', desc = 'Toggle markdown preview (browser)' },
    },
  },

  -- ── Treesitter ─────────────────────────────────────────────────────────
  {
    'nvim-treesitter/nvim-treesitter',
    lazy  = false,
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').setup {
        auto_install     = true,
        ensure_installed = { 'lua', 'python', 'typescript', 'javascript', 'tsx', 'html', 'css', 'json', 'bash', 'markdown', 'vim', 'vimdoc' },
      }
    end,
  },

  -- ── Formatting (manual only) ───────────────────────────────────────────
  {
    'stevearc/conform.nvim',
    cmd  = 'ConformInfo',
    keys = {
      { '<leader>cf', function() require('conform').format { async = true, lsp_format = 'never' } end, mode = { 'n', 'v' }, desc = 'Format' },
    },
    opts = {
      format_on_save = { timeout_ms = 500, lsp_format = 'never' },
      formatters_by_ft = {
        lua             = { 'stylua' },
        python          = { 'ruff_format', 'ruff_fix' },
        javascript      = { 'prettier' },
        javascriptreact = { 'prettier' },
        typescript      = { 'prettier' },
        typescriptreact = { 'prettier' },
        css             = { 'prettier' },
        html            = { 'prettier' },
        json            = { 'prettier' },
      },
    },
  },

  -- ── Completion ─────────────────────────────────────────────────────────
  {
    'saghen/blink.cmp',
    version = '1.*',
    opts = {
      keymap     = { preset = 'default' },
      appearance = { nerd_font_variant = 'mono' },
      sources    = {
        default   = { 'lsp', 'path', 'snippets', 'buffer', 'lazydev' },
        providers = {
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
        },
      },
      fuzzy = { implementation = 'prefer_rust' },
    },
  },

  -- ── LSP ────────────────────────────────────────────────────────────────
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'mason-org/mason.nvim',                    opts = {} },
      { 'mason-org/mason-lspconfig.nvim' },
      { 'WhoIsSethDaniel/mason-tool-installer.nvim' },
      { 'folke/lazydev.nvim', ft = 'lua',          opts = {} },
    },
    config = function()
      vim.lsp.config('*', {
        capabilities = require('blink.cmp').get_lsp_capabilities(),
      })

      -- Interpreter for a project: active venv, in-tree venv, else PATH python3.
      local function python_path(root)
        if vim.env.VIRTUAL_ENV then
          return vim.fs.joinpath(vim.env.VIRTUAL_ENV, 'bin', 'python')
        end
        for _, dir in ipairs { '.venv', 'venv', '.env' } do
          local candidate = vim.fs.joinpath(root or vim.fn.getcwd(), dir, 'bin', 'python')
          if vim.uv.fs_stat(candidate) then return candidate end
        end
        return vim.fn.exepath 'python3'
      end

      vim.lsp.config('lua_ls', {
        settings = { Lua = { completion = { callSnippet = 'Replace' } } },
      })

      -- Without pythonPath, pyright type-checks against the PATH interpreter
      -- instead of the project's venv.
      vim.lsp.config('pyright', {
        before_init = function(_, config)
          -- Mutated in place: the client shares this table, a reassignment would not reach it.
          config.settings.python = vim.tbl_deep_extend(
            'force',
            config.settings.python or {},
            { pythonPath = python_path(config.root_dir) }
          )
        end,
      })

      -- Install LSP servers via mason-lspconfig
      require('mason-lspconfig').setup {
        ensure_installed = { 'lua_ls', 'pyright', 'ruff', 'ts_ls' },
      }

      -- Install non-LSP tools (formatters) via mason-tool-installer
      require('mason-tool-installer').setup {
        ensure_installed = { 'stylua', 'prettier', 'ruff' },
      }

      -- Disable LSP formatting for ts_ls — use conform instead
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and (client.name == 'ts_ls' or client.name == 'eslint') then
            client.server_capabilities.documentFormattingProvider = false
          end
        end,
      })

      vim.diagnostic.config {
        severity_sort = true,
        float         = { border = 'rounded', source = 'if_many' },
        signs         = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN]  = '󰀪 ',
            [vim.diagnostic.severity.INFO]  = '󰋽 ',
            [vim.diagnostic.severity.HINT]  = '󰌶 ',
          },
        } or {},
      }
    end,
  },

  -- ── Database ────────────────────────────────────────────────────────────────
    {
      'kristijanhusak/vim-dadbod-ui',
    dependencies = {
     { 'tpope/vim-dadbod', lazy = true },
     { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true }, -- Optional
    },
    cmd = {
     'DBUI',
     'DBUIToggle',
     'DBUIAddConnection',
     'DBUIFindBuffer',
    },
    init = function()
     -- Your DBUI configuration
     vim.g.db_ui_use_nerd_fonts = 1
    end,
 },
  
  -- ── Git ────────────────────────────────────────────────────────────────

  {
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd  = { 'DiffviewOpen', 'DiffviewFileHistory', 'DiffviewClose' },
    opts = { enhanced_diff_hl = true },
    keys = {
      { '<leader>gv', function() vim.cmd('DiffviewOpen ' .. git_base_range()) end, desc = 'Diff branch vs base' },
      { '<leader>gV', '<cmd>DiffviewOpen<cr>',          desc = 'Diff working tree' },
      { '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', desc = 'File history (current file)' },
      { '<leader>gH', '<cmd>DiffviewFileHistory<cr>',   desc = 'File history (branch)' },
      { '<leader>gq', '<cmd>DiffviewClose<cr>',         desc = 'Close diffview' },
    },
  },
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add          = { text = '┃' },
        change       = { text = '┃' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
      },
      preview_config = { border = 'rounded' },
      on_attach = function(bufnr)
        local gs  = require 'gitsigns'
        local map = function(mode, l, r, opts)
          vim.keymap.set(mode, l, r, vim.tbl_extend('force', { buffer = bufnr }, opts or {}))
        end

        map('n', ']c', function()
          if vim.wo.diff then vim.cmd.normal { ']c', bang = true } else gs.nav_hunk 'next' end
        end, { desc = 'Next hunk' })
        map('n', '[c', function()
          if vim.wo.diff then vim.cmd.normal { '[c', bang = true } else gs.nav_hunk 'prev' end
        end, { desc = 'Prev hunk' })

        map('n', '<leader>hb', gs.blame_line,                { desc = 'Blame line' })
        map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = 'Toggle blame' })
        map('n', '<leader>hs', gs.stage_hunk,                { desc = 'Stage hunk' })
        map('n', '<leader>hr', gs.reset_hunk,                { desc = 'Reset hunk' })
        map('n', '<leader>hS', gs.stage_buffer,              { desc = 'Stage buffer' })
        map('n', '<leader>hR', gs.reset_buffer,              { desc = 'Reset buffer' })
        map('n', '<leader>hp', gs.preview_hunk,              { desc = 'Preview hunk' })
        map('n', '<leader>tD', gs.preview_hunk_inline,       { desc = 'Preview hunk inline' })
        map('v', '<leader>hs', function() gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = 'Stage hunk' })
        map('v', '<leader>hr', function() gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = 'Reset hunk' })
      end,
    },
  },

  -- ── Colorscheme ────────────────────────────────────────────────────────
  {
    'catppuccin/nvim',
    name     = 'catppuccin',
    priority = 1000,
    lazy     = false,
    config   = function()
      require('catppuccin').setup {
        flavour    = 'auto',
        background = { light = 'latte', dark = 'mocha' },
        integrations = {
          treesitter = true,
          blink_cmp  = true,
          gitsigns   = true,
          which_key  = true,
          snacks     = true,
          mini       = { enabled = true },
        },
      }
      vim.cmd.colorscheme 'catppuccin'
    end,
  },

  -- ── Winbar ─────────────────────────────────────────────────────────
  {
    'utilyre/barbecue.nvim',
    name         = 'barbecue',
    version      = '*',
    dependencies = {
      'SmiteshP/nvim-navic',
      'nvim-tree/nvim-web-devicons',
    },
    opts = {},
  },

  -- ── UI ─────────────────────────────────────────────────────────────────
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function()
      local wk = require 'which-key'
      wk.setup {}
      wk.add {
        { '<leader>c', group = 'Code' },
        { '<leader>g', group = 'Git' },
        { '<leader>h', group = 'Hunks', mode = { 'n', 'v' } },
        { '<leader>r', group = 'Refactor' },
        { '<leader>s', group = 'Search' },
        { '<leader>t', group = 'Toggle' },
        { '<leader>u', group = 'UI' },
      }
    end,
  },

  -- ── Snacks ─────────────────────────────────────────────────────────────
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy     = false,
    opts     = function()
      return {
        picker   = {
          enabled = true,
          sources = {
            git_diff = { layout = { preset = 'sidebar' } },
          },
        },
        notifier = { enabled = true },
        lazygit  = { enabled = true, win = { style = 'fullscreen' } },
        scroll   = {
			enabled = true,
			animate = {
				duration = { step = 5, duration = 150}
			}

		},
      }
    end,
    keys = {
      -- Files / search
      { '<leader>f',  function() Snacks.picker.smart() end,           desc = 'Find files' },
      { '<leader>sf', function() Snacks.picker.files() end,           desc = 'Find files (all)' },
      { '<leader>sb', function() Snacks.picker.buffers() end,         desc = 'Buffers' },
      { '<leader>/',  function() Snacks.picker.grep() end,            desc = 'Grep' },
      { '<leader>?',  function() Snacks.picker.lines() end,           desc = 'Buffer lines' },
      { '<leader>sk', function() Snacks.picker.keymaps() end,         desc = 'Keymaps' },
      { '<leader>:',  function() Snacks.picker.command_history() end, desc = 'Command history' },
      { '<leader>sd', function() Snacks.picker.diagnostics() end,     desc = 'Diagnostics' },
      -- Git
      { '<leader>n',  function() Snacks.notifier.show_history() end,  desc = 'Notifications' },
      { '<leader>l',  function() Snacks.lazygit() end,                desc = 'Lazygit' },
      { '<leader>gl', function() Snacks.picker.git_log() end,         desc = 'Git log' },
      { '<leader>gs', function() Snacks.picker.git_status() end,      desc = 'Git status' },
      { '<leader>gd', function() Snacks.picker.git_diff() end,        desc = 'Git diff' },
      -- LSP
      { 'gd',         function() Snacks.picker.lsp_definitions() end,      desc = 'Go to definition' },
      { 'gr',         function() Snacks.picker.lsp_references() end,       desc = 'References', nowait = true },
      { 'gI',         function() Snacks.picker.lsp_implementations() end,  desc = 'Go to implementation' },
      { 'gy',         function() Snacks.picker.lsp_type_definitions() end, desc = 'Go to type definition' },
      { '<leader>ss', function() Snacks.picker.lsp_symbols() end,          desc = 'LSP symbols' },
      { '<leader>sS', function() Snacks.picker.lsp_workspace_symbols() end, desc = 'LSP workspace symbols' },
    },
  },
}
