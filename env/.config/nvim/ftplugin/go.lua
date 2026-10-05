-- ftplugin/go.lua
-- Buffer-local Go settings. Loaded automatically by Neovim for every *.go buffer.
-- LSP config (gopls) lives in lua/lsp/go.lua.
-- Format-on-save via conform (gofumpt) — no redundant BufWritePre here.

-- Go canonical style: hard tabs, not spaces
vim.opt_local.expandtab  = false
vim.opt_local.tabstop    = 4
vim.opt_local.shiftwidth = 4

-- Enable LSP semantic tokens for gopls (richer highlighting)
vim.opt_local.spell = false

-- Go-specific keymaps
local map = vim.keymap.set
local opts = { buffer = true, silent = true }

-- Run the current package's tests
map("n", "<leader>gt", "<cmd>!go test ./...<CR>",           vim.tbl_extend("force", opts, { desc = "Go: test ./..." }))
-- Run just the test under the cursor (requires vim-go or manual :!go test -run …)
map("n", "<leader>gT", function()
    -- Extract function name under cursor (works for TestXxx functions)
    local fn_name = vim.fn.expand("<cword>")
    vim.cmd("!go test -v -run " .. fn_name .. " ./...")
end, vim.tbl_extend("force", opts, { desc = "Go: test func under cursor" }))

-- go build (surface compile errors in quickfix)
map("n", "<leader>gb", "<cmd>!go build ./...<CR>",          vim.tbl_extend("force", opts, { desc = "Go: build" }))
-- go vet
map("n", "<leader>gv", "<cmd>!go vet ./...<CR>",            vim.tbl_extend("force", opts, { desc = "Go: vet" }))
-- tidy
map("n", "<leader>gm", "<cmd>!go mod tidy<CR>",             vim.tbl_extend("force", opts, { desc = "Go: mod tidy" }))
