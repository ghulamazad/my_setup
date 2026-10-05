-- lua/lsp/node.lua
-- vtsls: modern TypeScript/JavaScript server (replaces old tsserver wrapper).
-- Owner: Mason (mason-lspconfig ensures_installed). NOT pacman.
-- Reason: vtsls is not in the Arch official repos; typescript-language-server
-- (the tsserver wrapper) is inferior. Mason manages this one editor-internally.

vim.lsp.config("vtsls", {
    settings = {
        typescript = {
            inlayHints = {
                parameterNames         = { enabled = "literals" },  -- only literal args, less noise
                variableTypes          = { enabled = false },
                propertyDeclarationTypes = { enabled = false },
            },
            updateImportsOnFileMove = { enabled = "always" },
        },
        javascript = {
            inlayHints = {
                parameterNames = { enabled = "literals" },
            },
        },
    },
})
