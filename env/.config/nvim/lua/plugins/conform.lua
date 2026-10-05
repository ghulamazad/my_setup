-- lua/plugins/conform.lua
-- conform.nvim: async format-on-save with per-filetype formatter chains.
--
-- Ownership note: all formatters here are pacman-installed system binaries.
--   gofumpt   → go (pacman: gofumpt)
--   rustfmt   → rust (pacman: rust — bundled with rustup/pacman rust)
--   ruff      → python (pacman: ruff)
--   prettier  → js/ts/json/yaml/markdown (pacman: prettier)
--   stylua    → lua (pacman: stylua)
--   clang-format → cpp (pacman: clang)
--
-- Format-on-save is ON by default. <leader>F is an explicit "format now" map.
-- Note: <leader>f in core/lsp.lua calls vim.lsp.buf.format (LSP-side manual).
--       conform is the primary path; LSP format is the fallback for unknown types.

return {
    {
        "stevearc/conform.nvim",
        event = "BufWritePre",
        keys = {
            {
                "<leader>F",
                function()
                    require("conform").format({ async = true, lsp_fallback = true })
                end,
                desc = "Format buffer (conform)",
            },
        },
        opts = {
            -- ── Formatter chains per filetype ─────────────────────────────────
            formatters_by_ft = {
                go         = { "gofumpt" },
                rust       = { "rustfmt" },
                python     = { "ruff_format" },
                lua        = { "stylua" },
                cpp        = { "clang_format" },
                c          = { "clang_format" },
                typescript = { "prettier" },
                javascript = { "prettier" },
                typescriptreact = { "prettier" },
                javascriptreact = { "prettier" },
                json       = { "prettier" },
                yaml       = { "prettier" },
                markdown   = { "prettier" },
                html       = { "prettier" },
                css        = { "prettier" },
            },

            -- ── Format-on-save ────────────────────────────────────────────────
            format_on_save = function(bufnr)
                -- Disable format-on-save for buffers where the user set the
                -- vim.b.disable_autoformat flag (e.g., :ConformDisable for that buffer).
                if vim.b[bufnr].disable_autoformat or vim.g.disable_autoformat then
                    return
                end
                return {
                    timeout_ms   = 2000,
                    lsp_fallback = true,   -- fall back to LSP if no conform formatter found
                }
            end,

            -- ── Formatter overrides ───────────────────────────────────────────
            formatters = {
                -- gofumpt is stricter gofmt; run it via its binary, not gopls.
                gofumpt = {
                    command = "gofumpt",
                    args    = { "-" },
                    stdin   = true,
                },
                stylua = {
                    -- stylua.toml at repo root controls indent/line width per project
                    prepend_args = { "--search-parent-directories" },
                },
            },

            -- ── Notification ──────────────────────────────────────────────────
            notify_on_error = true,
        },

        -- Add :ConformDisable / :ConformEnable convenience commands
        config = function(_, opts)
            require("conform").setup(opts)

            vim.api.nvim_create_user_command("ConformDisable", function(args)
                if args.bang then
                    -- :ConformDisable! → disable for all buffers
                    vim.g.disable_autoformat = true
                else
                    vim.b.disable_autoformat = true
                end
            end, { desc = "Disable format-on-save", bang = true })

            vim.api.nvim_create_user_command("ConformEnable", function()
                vim.b.disable_autoformat = false
                vim.g.disable_autoformat = false
            end, { desc = "Enable format-on-save" })
        end,
    },
}
