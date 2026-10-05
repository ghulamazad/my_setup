-- lua/plugins/treesitter.lua
-- nvim-treesitter: syntax highlighting, indentation, and structural text objects.
-- Grammars are compiled locally; parsers listed here are auto-installed.
-- Textobjects (via nvim-treesitter-textobjects) give function/class motions.

return {
    {
        "nvim-treesitter/nvim-treesitter",
        build  = ":TSUpdate",
        event  = { "BufReadPost", "BufNewFile" },
        dependencies = {
            -- Structural text objects: af/if, ac/ic, etc.
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
        config = function()
            require("nvim-treesitter.configs").setup({
                -- ── Parsers ───────────────────────────────────────────────────
                ensure_installed = {
                    -- Shell
                    "bash", "fish",
                    -- Go ecosystem
                    "go", "gomod", "gosum", "gowork",
                    -- Rust
                    "rust",
                    -- Python
                    "python",
                    -- TypeScript / JS
                    "typescript", "javascript", "tsx", "jsdoc",
                    -- C / C++ (competitive programming)
                    "c", "cpp",
                    -- Data / config
                    "json", "json5", "jsonc",
                    "yaml", "toml",
                    "proto",
                    -- Markup / docs
                    "markdown", "markdown_inline",
                    "html", "css",
                    -- Neovim
                    "lua", "luadoc", "luap",
                    "vim", "vimdoc", "query",
                    -- Misc
                    "dockerfile", "make", "sql",
                    "gitcommit", "gitignore",
                },

                -- ── Core modules ──────────────────────────────────────────────
                highlight = {
                    enable = true,
                    -- Disable for very large files (>500 KB) to avoid lag
                    disable = function(_, buf)
                        local max_filesize = 500 * 1024
                        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                        return ok and stats and stats.size > max_filesize
                    end,
                    additional_vim_regex_highlighting = false,
                },

                indent = { enable = true },

                -- ── Text objects ──────────────────────────────────────────────
                textobjects = {
                    select = {
                        enable    = true,
                        lookahead = true,   -- jump to next matching object
                        keymaps = {
                            -- Functions
                            ["af"] = { query = "@function.outer", desc = "Around function" },
                            ["if"] = { query = "@function.inner", desc = "Inside function" },
                            -- Classes / structs
                            ["ac"] = { query = "@class.outer",    desc = "Around class" },
                            ["ic"] = { query = "@class.inner",    desc = "Inside class" },
                            -- Blocks (if, loop, etc.)
                            ["ab"] = { query = "@block.outer",    desc = "Around block" },
                            ["ib"] = { query = "@block.inner",    desc = "Inside block" },
                            -- Parameters / arguments
                            ["aa"] = { query = "@parameter.outer", desc = "Around argument" },
                            ["ia"] = { query = "@parameter.inner", desc = "Inside argument" },
                        },
                    },
                    move = {
                        enable               = true,
                        set_jumps            = true,  -- populate jumplist
                        goto_next_start      = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
                        goto_next_end        = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
                        goto_previous_start  = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
                        goto_previous_end    = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
                    },
                    swap = {
                        enable = true,
                        swap_next     = { ["<leader>sp"] = "@parameter.inner" },
                        swap_previous = { ["<leader>sP"] = "@parameter.inner" },
                    },
                },
            })
        end,
    },
}
