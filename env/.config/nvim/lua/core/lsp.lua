-- lua/core/lsp.lua
-- Problem: LSP keymaps and capabilities need to be wired once on attach, not per-server.
-- Uses the native vim.lsp LspAttach autocmd (nvim 0.11+, no lspconfig setup() needed).

local group = vim.api.nvim_create_augroup("UserLspConfig", {})

vim.api.nvim_create_autocmd("LspAttach", {
    group    = group,
    callback = function(event)
        local opts   = { buffer = event.buf, silent = true }
        local map    = vim.keymap.set
        local extend = vim.tbl_extend

        -- ── Navigation ────────────────────────────────────────────────────────
        map("n", "gd", vim.lsp.buf.definition,    extend("force", opts, { desc = "Go to definition" }))
        map("n", "gD", vim.lsp.buf.declaration,   extend("force", opts, { desc = "Go to declaration" }))
        map("n", "gr", vim.lsp.buf.references,    extend("force", opts, { desc = "References" }))
        map("n", "gI", vim.lsp.buf.implementation,extend("force", opts, { desc = "Go to implementation" }))
        map("n", "K",  vim.lsp.buf.hover,         extend("force", opts, { desc = "Hover docs" }))

        -- ── Actions ───────────────────────────────────────────────────────────
        map("n", "<leader>ca", vim.lsp.buf.code_action, extend("force", opts, { desc = "Code action" }))
        map("n", "<leader>rn", vim.lsp.buf.rename,      extend("force", opts, { desc = "Rename symbol" }))

        -- <leader>f: manual format (conform handles format-on-save for most filetypes;
        -- this is the explicit "format now" escape hatch).
        map("n", "<leader>f", function()
            vim.lsp.buf.format({ async = true })
        end, extend("force", opts, { desc = "Format buffer" }))

        -- Implement missing interface methods — wraps code_action with a filter
        -- so you don't have to scroll through all actions to find it.
        map("n", "<leader>ci", function()
            vim.lsp.buf.code_action({
                filter = function(action)
                    return action.title:lower():match("implement") ~= nil
                end,
                apply = true,
            })
        end, extend("force", opts, { desc = "Implement missing methods" }))

        -- ── Diagnostics ───────────────────────────────────────────────────────
        -- vim.diagnostic.jump is the 0.11+ API (replaces goto_next/goto_prev).
        map("n", "]d", function()
            vim.diagnostic.jump({ count = 1,  float = true })
        end, extend("force", opts, { desc = "Next diagnostic" }))
        map("n", "[d", function()
            vim.diagnostic.jump({ count = -1, float = true })
        end, extend("force", opts, { desc = "Prev diagnostic" }))
        map("n", "<leader>ld", vim.diagnostic.open_float,
            extend("force", opts, { desc = "Line diagnostics" }))

        -- ── Inlay hints toggle ────────────────────────────────────────────────
        -- gopls and rust-analyzer support these. Off by default (visually dense).
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client:supports_method("textDocument/inlayHint") then
            map("n", "<leader>ih", function()
                local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf })
                vim.lsp.inlay_hint.enable(not enabled, { bufnr = event.buf })
            end, extend("force", opts, { desc = "Toggle inlay hints" }))
        end
    end,
})

-- ── Capabilities ──────────────────────────────────────────────────────────────
-- Augment base capabilities with blink.cmp's completion protocol extensions.
-- Wrapped in pcall: on first boot lazy.nvim hasn't installed blink yet.
local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok, blink = pcall(require, "blink.cmp")
if ok then
    capabilities = blink.get_lsp_capabilities(capabilities)
end

-- Apply globally: every server picks up these capabilities automatically.
vim.lsp.config("*", {
    capabilities = capabilities,
})
