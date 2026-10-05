-- lua/plugins/mason.lua
-- Problem: Mason manages editor-internal tools that aren't in pacman or mise.
--
-- Tool ownership strategy (one owner per tool):
--   pacman    → gopls, gofumpt, delve, rust-analyzer, pyright, ruff, stylua, prettier
--   mise      → Go runtime, Node runtime, Python runtime, golangci-lint
--   Mason     → vtsls (TS server not in repos), clangd (CP use), debugpy, codelldb
--
-- mason-lspconfig is intentionally NOT used for the pacman-owned servers
-- (gopls, rust_analyzer, pyright, ruff). Adding them to ensure_installed
-- would install a second copy that could shadow the system binary.
-- The nvim 0.11 native API (vim.lsp.config / vim.lsp.enable) + mason-lspconfig's
-- automatic_enable flag handles the Mason-owned servers automatically.

return {
    -- mason.nvim: the package manager UI and registry
    {
        "mason-org/mason.nvim",
        cmd   = "Mason",
        build = ":MasonUpdate",
        opts  = {
            ui = {
                border = "rounded",
                icons  = {
                    package_installed   = "✓",
                    package_pending     = "➜",
                    package_uninstalled = "✗",
                },
            },
        },
    },

    -- mason-lspconfig: only for servers Mason owns (vtsls, clangd)
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
        opts = {
            ensure_installed = {
                "vtsls",   -- TypeScript/JS — not in Arch repos; Mason owns this
                "clangd",  -- C++ for competitive programming
                -- gopls, rust_analyzer, pyright, ruff → owned by pacman, NOT here
            },
            -- Calls vim.lsp.enable() for each installed server automatically.
            -- Our per-server vim.lsp.config() calls in lua/lsp/*.lua supply settings.
            automatic_enable = true,
        },
    },

    -- nvim-lspconfig: ships default server configs (cmd, root_dir, etc.)
    -- On nvim 0.11+: data source only, not an imperative setup() API.
    { "neovim/nvim-lspconfig" },

    -- mason-tool-installer: installs DAP adapters and any formatters
    -- that aren't already owned by pacman.
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = { "mason-org/mason.nvim" },
        opts = {
            ensure_installed = {
                -- DAP adapters (pacman has no nvim-dap integration packages for these)
                "debugpy",  -- Python debugger adapter
                "codelldb", -- Rust/C++ debugger adapter
                -- formatters: prettier + stylua are in pacman; no need to duplicate
                -- Add Mason-only formatters here if you add a language with no pacman package
            },
        },
    },
}
