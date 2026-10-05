-- lua/core/keymaps.lua
-- Global (non-LSP) keymaps. LSP-specific maps live in core/lsp.lua LspAttach.

vim.g.mapleader      = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set

-- Clear search highlight without losing the search register
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Centred half-page jumps — cursor stays in the middle of the screen
map("n", "<C-d>", "<C-d>zz", { desc = "Half-page down, centred" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half-page up, centred" })

-- Centred search result navigation
map("n", "n", "nzzzv", { desc = "Next result, centred" })
map("n", "N", "Nzzzv", { desc = "Prev result, centred" })

-- Move selected lines in visual mode without losing the selection
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Better window navigation (C-hjkl also handled by vim-tmux-navigator)
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })

-- Resize splits with arrow keys (fast, no prefix needed)
map("n", "<C-Up>",    "<cmd>resize +2<CR>",          { desc = "Resize up" })
map("n", "<C-Down>",  "<cmd>resize -2<CR>",          { desc = "Resize down" })
map("n", "<C-Left>",  "<cmd>vertical resize -2<CR>", { desc = "Resize left" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Resize right" })

-- Buffer navigation
map("n", "<S-l>", "<cmd>bnext<CR>",     { desc = "Next buffer" })
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Prev buffer" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })

-- Quickfix list navigation (used heavily with :grep / LSP diagnostics)
map("n", "]q", "<cmd>cnext<CR>",  { desc = "Next quickfix" })
map("n", "[q", "<cmd>cprev<CR>",  { desc = "Prev quickfix" })
map("n", "<leader>q", "<cmd>copen<CR>", { desc = "Open quickfix list" })

-- Paste without overwriting the yank register in visual mode
map("v", "<leader>p", '"_dP', { desc = "Paste without losing yank" })

-- Yank to system clipboard explicitly (C-c copies selection)
map("n", "<leader>y", '"+y', { desc = "Yank to clipboard" })
map("v", "<leader>y", '"+y', { desc = "Yank to clipboard" })

-- Open a lazy terminal split at the project root
map("n", "<leader>tt", function()
    local root = vim.fs.root(0, { ".git", "go.mod", "Cargo.toml", "package.json" })
        or vim.fn.getcwd()
    vim.cmd("botright 14split")
    vim.cmd("terminal cd " .. vim.fn.shellescape(root))
    vim.cmd("startinsert")
end, { desc = "Terminal at project root" })
