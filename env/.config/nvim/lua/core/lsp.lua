local group = vim.api.nvim_create_augroup("UserLspConfig", {})

vim.api.nvim_create_autocmd("LspAttach", {
  group = group,
  callback = function(event)
    local opts = { buffer = event.buf, silent = true }
    local keymap = vim.keymap.set

    -- Navigation — these override Neovim's native gd/gr etc. with
    -- LSP-aware versions, but keep the same muscle-memory keys
    keymap("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
    keymap("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
    keymap("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Go to references" }))
    keymap("n", "gI", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
    keymap("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover documentation" }))

    -- Actions
    keymap("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
    keymap("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
    keymap("n", "<leader>f", function()
      vim.lsp.buf.format({ async = true })
    end, vim.tbl_extend("force", opts, { desc = "Format buffer" }))

    -- Diagnostics navigation (native vim.diagnostic API, 0.11+ signature)
    keymap("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end,
      vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
    keymap("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end,
      vim.tbl_extend("force", opts, { desc = "Prev diagnostic" }))
    keymap("n", "<leader>ld", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "Line diagnostics" }))
    -- Inlay hints toggle — gopls and rust-analyzer both support these
    -- (parameter names, inferred types shown inline). Off by default
    -- here because it's visually dense; you toggle it on when useful.
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method("textDocument/inlayHint") then
      keymap("n", "<leader>ih", function()
        local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf })
        vim.lsp.inlay_hint.enable(not enabled, { bufnr = event.buf })
      end, vim.tbl_extend("force", opts, { desc = "Toggle inlay hints" }))
    end
  end,
})

-- lua/core/lsp.lua  (replace the capabilities block from Stage 2)
local capabilities = vim.lsp.protocol.make_client_capabilities()

-- blink.cmp augments base capabilities with its own completion
-- protocol extensions. Wrapped in pcall because this file loads
-- before blink.cmp is guaranteed to be installed on a first-ever
-- `nvim` run (lazy.nvim installs plugins asynchronously on first boot).
local ok, blink = pcall(require, "blink.cmp")
if ok then
  capabilities = blink.get_lsp_capabilities(capabilities)
end

vim.lsp.config("*", {
  capabilities = capabilities,
})