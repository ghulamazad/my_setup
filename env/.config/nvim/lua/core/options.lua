-- Disable netrw entirely — neo-tree (Stage 9) replaces it completely,
-- and leaving netrw loaded means its own keymaps/autocmds stick
-- around and can silently collide with ours (e.g. <C-l> was bound
-- to netrw's buffer-refresh by default until this disabled it).
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local opt = vim.opt

-- Line numbers: relative for fast motion (5j/5k), absolute on current line
opt.number = true
opt.relativenumber = true

-- Indentation: default to 4 spaces (Java/JS/Python convention).
-- Go is the outlier — gofmt enforces tabs — we override this
-- per-filetype later via an ftplugin, not globally here.
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

-- Search: case-insensitive unless you type a capital letter
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true

-- Splits: open where you'd expect (right/below), not left/above
opt.splitright = true
opt.splitbelow = true

-- Persistent undo across sessions/reboots
opt.undofile = true
opt.undodir = vim.fn.stdpath("state") .. "/undo"

-- Faster feedback loops:
-- updatetime controls how soon CursorHold fires (LSP diagnostics,
-- hover-on-idle) — default 4000ms feels laggy, 250ms feels responsive
opt.updatetime = 250
-- timeoutlen controls how long Neovim waits for a mapped key sequence
-- to complete (matters a lot once we add which-key style leader maps)
opt.timeoutlen = 300

-- Keep some context around the cursor when scrolling
opt.scrolloff = 8
opt.sidescrolloff = 8

-- System clipboard integration (yank/paste shares with OS clipboard)
opt.clipboard = "unnamedplus"

-- Mouse support (useful for tmux pane resizing interplay, not for editing)
opt.mouse = "a"

-- Sign column always visible (prevents text-shift when diagnostics/git signs appear)
opt.signcolumn = "yes"

-- True color support (your terminal + Nerd Font can handle this)
opt.termguicolors = true

-- Reduce visual noise: no wrap for code, show invisible chars deliberately
opt.wrap = false
opt.list = true
opt.listchars = { tab = "→ ", trail = "·", nbsp = "␣" }

-- Command-line height: 1 is enough, keeps more code visible
opt.cmdheight = 1

-- Global statusline (one statusline for all splits, not per-window)
opt.laststatus = 3