-- lua/lsp/go.lua
-- gopls configuration. gopls is installed via pacman (system-wide).
-- Mason does NOT manage gopls — no double installation.

vim.lsp.config("gopls", {
    settings = {
        gopls = {
            -- staticcheck: stricter analysis than gopls built-in (catches unused fields etc.)
            staticcheck = true,

            -- gofumpt: enforces stricter formatting on top of gofmt.
            -- Does NOT organize imports — that is a separate code action below.
            gofumpt = true,

            analyses = {
                unusedparams = true,
                shadow       = true,
            },

            -- usePlaceholders: function args become tab-stops on completion
            usePlaceholders = true,

            -- Inlay hints: off globally, toggled per-buffer with <leader>ih
            hints = {
                assignVariableTypes    = true,
                compositeLiteralFields = true,
                constantValues         = true,
                parameterNames         = true,
                rangeVariableTypes     = true,
            },
        },
    },
})

-- On save: organise imports THEN format. Two separate LSP requests.
-- gopls does not combine them — order matters (organise first, then format).
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern  = "*.go",
    callback = function(args)
        local client = vim.lsp.get_clients({ bufnr = args.buf, name = "gopls" })[1]
        if not client then return end

        -- 1. Organise imports
        local params   = vim.lsp.util.make_range_params(0, client.offset_encoding)
        params.context = { only = { "source.organizeImports" } }
        local res      = vim.lsp.buf_request_sync(args.buf, "textDocument/codeAction", params, 1000)
        for _, r in pairs(res or {}) do
            for _, action in pairs(r.result or {}) do
                if action.edit then
                    vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
                end
            end
        end

        -- 2. Format (gofumpt via gopls)
        vim.lsp.buf.format({ async = false })
    end,
})
