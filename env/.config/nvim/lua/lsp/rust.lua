-- lua/lsp/rust.lua
-- rust-analyzer installed via pacman (system-wide). Mason does NOT manage it.

vim.lsp.config("rust_analyzer", {
    settings = {
        ["rust-analyzer"] = {
            cargo = {
                allFeatures         = true,  -- analyse code behind feature flags too
                loadOutDirsFromCheck = true,
            },
            checkOnSave = true,
            check = {
                command = "clippy",  -- clippy catches more than plain cargo check
            },
            inlayHints = {
                bindingModeHints      = { enable = false },              -- too noisy
                closureReturnTypeHints = { enable = "with_block" },
                lifetimeElisionHints  = { enable = "skip_trivial" },
            },
        },
    },
})
