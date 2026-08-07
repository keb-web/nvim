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
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      local servers = {
        lua_ls  = {
          settings = { Lua = { completion = { callSnippet = 'Replace' } } },
        },
        pyright = {},
        ruff    = {},
        ts_ls   = {},
      }

      -- Install LSP servers via mason-lspconfig
      require('mason-lspconfig').setup {
        ensure_installed = vim.tbl_keys(servers),
        handlers = {
          function(server_name)
            local cfg = vim.tbl_deep_extend('force', { capabilities = capabilities }, servers[server_name] or {})
            require('lspconfig')[server_name].setup(cfg)
          end,
        },
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

  -- ── Git ────────────────────────────────────────────────────────────────
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
        flavour              = 'mocha',
        transparent_background = true,
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
      -- Terminal is transparent, so make ONLY the git_diff picker transparent
      -- (grep/files stay solid). Per-source winhighlight is overwritten by
      -- snacks, so toggle the shared picker hl groups while git_diff is open
      -- and restore their originals on close.
      local groups = { 'SnacksPicker', 'SnacksPickerList', 'SnacksPickerInput' }
      local saved  = {}
      return {
        picker   = {
          enabled = true,
          sources = {
            git_diff = {
              layout  = { preset = 'sidebar' },
              on_show = function()
                for _, g in ipairs(groups) do
                  saved[g] = vim.api.nvim_get_hl(0, { name = g, link = true })
                  vim.api.nvim_set_hl(0, g, { bg = 'NONE' })
                end
              end,
              on_close = function()
                for _, g in ipairs(groups) do
                  vim.api.nvim_set_hl(0, g, saved[g] or { link = 'NormalFloat' })
                end
              end,
            },
          },
        },
        notifier = { enabled = true },
        lazygit  = { enabled = true, win = { style = 'fullscreen' } },
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
