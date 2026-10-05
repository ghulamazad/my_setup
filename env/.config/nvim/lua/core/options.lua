-- lua/core/options.lua → same as lua/config/options.lua; actual file is here.
-- This file is the package-mirrored path used by install-config.sh.
-- Content is identical; symlink or copy either path — they are the same file.

-- Disable netrw so neo-tree takes over `nvim <dir>` entirely.
vim.g.loaded_netrw       = 1
vim.g.loaded_netrwPlugin = 1

local opt = vim.opt

opt.number         = true
opt.relativenumber = true

opt.tabstop    = 4
opt.shiftwidth = 4
opt.expandtab  = true
opt.smartindent = true

opt.ignorecase = true
opt.smartcase  = true
opt.incsearch  = true

opt.splitright = true
opt.splitbelow = true

opt.undofile = true
opt.undodir  = vim.fn.stdpath("state") .. "/undo"
opt.swapfile = false

opt.updatetime  = 250
opt.timeoutlen  = 300

opt.scrolloff     = 8
opt.sidescrolloff = 8

opt.clipboard = "unnamedplus"
opt.mouse     = "a"

opt.signcolumn    = "yes"
opt.termguicolors = true
opt.wrap          = false
opt.cmdheight     = 1
opt.laststatus    = 3
opt.showmode      = false
opt.pumheight     = 10
opt.completeopt   = "menu,menuone,noselect"

opt.grepprg    = "rg --vimgrep --smart-case"
opt.grepformat = "%f:%l:%c:%m"
