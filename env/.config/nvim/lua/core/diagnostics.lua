-- lua/core/diagnostics.lua
-- Problem: default diagnostic display is too noisy and unstyled.
-- These settings apply globally before any LSP client attaches.

vim.diagnostic.config({
    virtual_text = {
        prefix  = "●",
        spacing = 4,
    },
    severity_sort    = true,   -- errors always above warnings in the list
    underline        = true,
    update_in_insert = false,  -- no flickering while you type
    float = {
        border = "rounded",
        source = true,         -- shows which LSP raised the diagnostic
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN]  = "",
            [vim.diagnostic.severity.HINT]  = "",
            [vim.diagnostic.severity.INFO]  = "",
        },
    },
})
