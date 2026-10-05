-- lua/lsp/python.lua
-- pyright + ruff. Both installed via pacman (system-wide).
-- Mason does NOT manage these. Mason handles DAP (debugpy) only.

-- pyright: type checker / IntelliSense
vim.lsp.config("pyright", {
    settings = {
        pyright = {
            -- ruff owns import organisation; disable pyright's to avoid duplicate actions.
            disableOrganizeImports = true,
        },
        python = {
            analysis = {
                typeCheckingMode      = "basic",  -- "strict" available if you want it
                autoImportCompletions = true,
            },
        },
    },
})

-- ruff: fast linter + import organiser (complements pyright, doesn't replace it)
vim.lsp.config("ruff", {
    init_options = {
        settings = {
            organizeImports = true,
        },
    },
})
