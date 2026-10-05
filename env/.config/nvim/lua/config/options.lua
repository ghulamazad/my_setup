-- lua/core/options.lua
-- Source of truth for vim.opt settings.
-- Mirrors your live config; see comments for why each option is here.

-- Disable netrw so neo-tree takes over `nvim <dir>` entirely.
-- Netrw's own keymaps (like <C-l>) would otherwise collide with tmux-navigator.
vim.g.loaded_netrw       = 1
vim.g.loaded_netrwPlugin = 1

local opt = vim.opt

-- ── Line numbers ──────────────────────────────────────────────────────────────
opt.number         = true   -- absolute number on current line
opt.relativenumber = true   -- relative on all other lines — fast j/k motion

-- ── Indentation ───────────────────────────────────────────────────────────────
-- Default to 4 spaces. Go's tabs are enforced by gofumpt, not here.
-- Per-language overrides live in ftplugin/*.lua (2 spaces for Lua/TS/JS).
opt.tabstop    = 4
opt.shiftwidth = 4
opt.expandtab  = true
opt.smartindent = true

-- ── Search ────────────────────────────────────────────────────────────────────
opt.ignorecase = true   -- case-insensitive by default
opt.smartcase  = true   -- re-enable case when you type an uppercase letter
opt.incsearch  = true   -- live highlight while typing

-- ── Splits ───────────────────────────────────────────────────────────────────
opt.splitright = true   -- :vs opens right (natural reading order)
opt.splitbelow = true   -- :sp opens below

-- ── Undo / swap ───────────────────────────────────────────────────────────────
opt.undofile = true     -- persist undo across sessions
opt.undodir  = vim.fn.stdpath("state") .. "/undo"
opt.swapfile = false    -- version control + undo file replaces swap

-- ── Performance / feedback ────────────────────────────────────────────────────
opt.updatetime  = 250   -- CursorHold fires in 250 ms (drives LSP hover, gitsigns)
opt.timeoutlen  = 300   -- key-sequence wait; short = which-key pops fast

-- ── Scrolling ─────────────────────────────────────────────────────────────────
opt.scrolloff     = 8
opt.sidescrolloff = 8

-- ── Clipboard ─────────────────────────────────────────────────────────────────
-- Wayland: requires wl-clipboard (wl-copy/wl-paste on PATH).
opt.clipboard = "unnamedplus"

-- ── Mouse ─────────────────────────────────────────────────────────────────────
opt.mouse = "a"   -- useful for tmux pane-resize interplay, not for editing

-- ── UI ────────────────────────────────────────────────────────────────────────
opt.signcolumn   = "yes"      -- always show; prevents layout shift on diagnostics
opt.termguicolors = true      -- 24-bit colour
opt.wrap         = false      -- code doesn't wrap
opt.cmdheight    = 1          -- one line is enough; keeps more code visible
opt.laststatus   = 3          -- single global statusline (lualine uses this)
opt.showmode     = false      -- mode shown in lualine, not the native cmdline
opt.pumheight    = 10         -- cap completion menu height
opt.completeopt  = "menu,menuone,noselect"  -- required by blink.cmp

-- ── Grep ─────────────────────────────────────────────────────────────────────
opt.grepprg    = "rg --vimgrep --smart-case"
opt.grepformat = "%f:%l:%c:%m"
