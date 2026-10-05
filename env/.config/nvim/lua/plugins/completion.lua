-- lua/plugins/completion.lua
-- blink.cmp: modern, blazing-fast completion written in Rust.
-- Replaces nvim-cmp. Handles sources, snippets, and LSP protocol extensions.

return {
    {
        "saghen/blink.cmp",
        version      = "*",       -- use latest stable release build
        event        = "InsertEnter",
        dependencies = {
            -- Snippet engine (LuaSnip for complex snippet bodies)
            { "L3MON4D3/LuaSnip", version = "v2.*" },
        },
        opts = {
            -- ── Keymap preset ─────────────────────────────────────────────────
            -- "default": Tab/S-Tab to navigate, Enter to confirm, C-space to
            -- open menu explicitly, C-e to close.
            keymap = { preset = "default" },

            -- ── Appearance ────────────────────────────────────────────────────
            appearance = {
                -- Use Nerd Font icons for kind labels (matches your lualine setup)
                use_nvim_cmp_as_default = false,
                nerd_font_variant = "mono",
            },

            -- ── Sources ───────────────────────────────────────────────────────
            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
                -- Score modifier: LSP items rank above buffer text matches
                providers = {
                    lsp     = { score_offset = 5 },
                    snippets = { score_offset = 3 },
                },
            },

            -- ── Snippets ──────────────────────────────────────────────────────
            snippets = {
                preset = "luasnip",
            },

            -- ── Completion behaviour ──────────────────────────────────────────
            completion = {
                -- Show documentation popup automatically beside the menu
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 200,
                    window = { border = "rounded" },
                },
                -- Ghost text (inline preview of the top suggestion)
                ghost_text = { enabled = true },
                menu = {
                    border = "rounded",
                    draw = {
                        -- Compact: icon + label + kind (no source column)
                        columns = { { "kind_icon" }, { "label", gap = 1 }, { "kind" } },
                    },
                },
            },

            -- ── Signature help ────────────────────────────────────────────────
            signature = {
                enabled = true,
                window  = { border = "rounded" },
            },

            -- ── Fuzzy matching ────────────────────────────────────────────────
            fuzzy = {
                -- Use the Rust-powered prebuilt binary for maximum speed
                use_typo_resistance = true,
                use_frecency        = true,
                use_proximity       = true,
            },
        },
    },
}
