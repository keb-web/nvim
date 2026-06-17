# nvim config

Minimal Neovim config built on [lazy.nvim](https://github.com/folke/lazy.nvim).

## Structure

```
~/.config/nvim/
├── init.lua          # options
├── lua/
│   ├── keymaps.lua   # general keymaps
│   ├── autocmds.lua  # autocommands (yank highlight, auto-save)
│   ├── lazy-bootstrap.lua
│   └── lazy-plugins.lua
```

## Plugins

| Plugin | Purpose |
|--------|---------|
| [snacks.nvim](https://github.com/folke/snacks.nvim) | File finder, grep, git pickers, lazygit |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) + [mason](https://github.com/mason-org/mason.nvim) | Language servers, auto-installed |
| [blink.cmp](https://github.com/saghen/blink.cmp) | Completion |
| [conform.nvim](https://github.com/stevearc/conform.nvim) | Formatting (manual only) |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlighting, indentation |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git hunk signs, blame, stage/reset |
| [which-key.nvim](https://github.com/folke/which-key.nvim) | Keymap hints |
| [mini.files](https://github.com/echasnovski/mini.files) | File explorer |
| [mini.ai](https://github.com/echasnovski/mini.ai) | Better text objects |
| [mini.splitjoin](https://github.com/echasnovski/mini.splitjoin) | Toggle split/join arguments |
| [mini.icons](https://github.com/echasnovski/mini.icons) | Icons |
| [nvim-autopairs](https://github.com/windwp/nvim-autopairs) | Auto-close brackets/quotes |
| [guess-indent.nvim](https://github.com/NMAC427/guess-indent.nvim) | Auto-detect indentation |

## Keymaps

Leader key: `Space`

### General

| Key | Action |
|-----|--------|
| `<leader>w` | Write |
| `<leader>q` | Quit |
| `<leader>L` | Open Lazy |
| `U` | Redo |
| `<M-Tab>` | Switch to last buffer |
| `<C-h/j/k/l>` | Move between splits |
| `<Esc>` | Clear search highlight |
| `<leader>ub` | Toggle dark/light background |
| `<leader>pwd` | Copy cwd to clipboard |

### Search (snacks)

| Key | Action |
|-----|--------|
| `<leader>f` | Smart file finder (recent + git files) |
| `<leader>sf` | Find all files |
| `<leader>sb` | Open buffers |
| `<leader>/` | Live grep |
| `<leader>?` | Search current buffer lines |
| `<leader>sk` | Keymaps |
| `<leader>sd` | Diagnostics |
| `<leader>:` | Command history |

### Files

| Key | Action |
|-----|--------|
| `<leader>e` | Open mini.files at current file |
| `<leader>E` | Open mini.files at cwd |

### LSP

> `grn`, `gra`, `K` are nvim 0.11 built-in defaults (rename, code action, hover).

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | References |
| `gI` | Go to implementation |
| `gy` | Go to type definition |
| `<leader>ss` | LSP symbols |
| `<leader>sS` | LSP workspace symbols |
| `<leader>cf` | Format buffer/selection |
| `<leader>Q` | Diagnostics (loclist) |

### Git

| Key | Action |
|-----|--------|
| `<leader>l` | Lazygit (fullscreen) |
| `<leader>gl` | Git log |
| `<leader>gs` | Git status |
| `<leader>gd` | Git diff |
| `]c` / `[c` | Next / prev hunk |
| `<leader>hs` / `<leader>hr` | Stage / reset hunk (normal + visual) |
| `<leader>hS` / `<leader>hR` | Stage / reset buffer |
| `<leader>hp` | Preview hunk |
| `<leader>hb` | Blame line |
| `<leader>tb` | Toggle inline blame |
| `<leader>tD` | Preview hunk inline |

### Editing

| Key | Action |
|-----|--------|
| `<leader>rs` | Toggle split/join arguments |

## LSP Servers

Auto-installed via Mason on first launch:

- `lua_ls` — Lua
- `pyright` — Python
- `ruff` — Python linting
- `ts_ls` — TypeScript / JavaScript

Formatters also auto-installed: `stylua`, `prettier`, `ruff`.

## Auto-save

Buffers are silently saved on `InsertLeave` and `TextChanged` (file buffers only, not diffs or special buffers).
