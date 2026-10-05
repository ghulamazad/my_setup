-- ftplugin/cpp.lua
-- Buffer-local C++ settings for competitive programming.
-- Loaded automatically for *.cpp / *.cc / *.cxx files.
-- LSP: clangd (Mason-owned, configured via mason-lspconfig automatic_enable).
-- Format-on-save: clang-format via conform.

-- CP style: 4-space indent, spaces not tabs
vim.opt_local.expandtab  = true
vim.opt_local.tabstop    = 4
vim.opt_local.shiftwidth = 4

-- Disable spell-check in code buffers
vim.opt_local.spell = false

-- ── Competitive programming keymaps ──────────────────────────────────────────
local map  = vim.keymap.set
local opts = { buffer = true, silent = true }

-- Compile + run in a bottom split (fast feedback loop)
map("n", "<leader>cr", function()
    local file   = vim.fn.expand("%:p")        -- full path to current file
    local binary = vim.fn.expand("%:p:r")      -- path without extension
    local cmd    = string.format(
        "g++ -std=c++17 -O2 -o %s %s && %s",
        vim.fn.shellescape(binary),
        vim.fn.shellescape(file),
        vim.fn.shellescape(binary)
    )
    vim.cmd("botright 14split")
    vim.cmd("terminal " .. cmd)
    vim.cmd("startinsert")
end, vim.tbl_extend("force", opts, { desc = "CP: compile & run" }))

-- Compile only (surface errors in terminal, then check quickfix via :cope)
map("n", "<leader>cc", function()
    local file   = vim.fn.expand("%:p")
    local binary = vim.fn.expand("%:p:r")
    vim.cmd("!g++ -std=c++17 -O2 -Wall -o " ..
        vim.fn.shellescape(binary) .. " " .. vim.fn.shellescape(file))
end, vim.tbl_extend("force", opts, { desc = "CP: compile only" }))

-- Open input file (input.txt) beside the source
map("n", "<leader>ci", function()
    local dir = vim.fn.expand("%:p:h")
    vim.cmd("vsplit " .. dir .. "/input.txt")
end, vim.tbl_extend("force", opts, { desc = "CP: open input.txt" }))
