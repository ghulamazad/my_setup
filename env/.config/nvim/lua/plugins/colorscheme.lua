-- lua/plugins/colorscheme.lua
-- Theme strategy for long coding sessions:
--
--   kanagawa-dragon  ← PRIMARY (default)
--     Darkest kanagawa variant. Deeply muted palette inspired by ink wash
--     painting — far less saturation than "wave". Eyes don't tire after 4-6h.
--     Backgrounds: bg #181616, surface #282727. Almost no pure white.
--
--   kanagawa-wave    ← secondary (slightly brighter; switch with <leader>tw)
--   rose-pine-moon   ← tertiary (warm purple tones; good after sunset)
--
-- Toggle with: <leader>t1 / <leader>t2 / <leader>t3

return {
    -- ── Primary: kanagawa (dragon variant) ───────────────────────────────────
    {
        "rebelot/kanagawa.nvim",
        lazy     = false,
        priority = 1000,
        opts = {
            compile   = false,
            undercurl = true,

            -- Typography: italicise comments + keywords so the eye
            -- categorises them subconsciously (less manual scanning).
            commentStyle   = { italic = true },
            keywordStyle   = { italic = true },
            functionStyle  = {},
            statementStyle = { bold = true },
            typeStyle      = {},

            -- dimInactive: fades non-focused splits so you never lose track
            -- of which pane you are editing. Very useful in multi-split layouts.
            dimInactive    = true,

            transparent    = false,
            terminalColors = true,

            colors = {
                theme = {
                    dragon = {
                        ui = {
                            bg_gutter = "none",  -- remove gutter background tint
                        },
                    },
                },
            },

            -- dragon: darkest variant — the one designed for long sessions.
            theme      = "dragon",
            background = { dark = "dragon", light = "lotus" },
        },

        config = function(_, opts)
            require("kanagawa").setup(opts)
            vim.cmd.colorscheme("kanagawa-dragon")

            -- ── Eye-care: reduce harshness after setup ──────────────────────
            -- Soften the cursor line: highlight only the line number, not the
            -- full line. This gives position awareness without a distracting bar.
            vim.api.nvim_set_hl(0, "CursorLineNr", { bold = true, fg = "#C8C093" })

            -- Search highlights: use a gentler amber instead of harsh yellow
            vim.api.nvim_set_hl(0, "Search",    { bg = "#49443C", fg = "#E6C384" })
            vim.api.nvim_set_hl(0, "IncSearch", { bg = "#C8C093", fg = "#181616", bold = true })

            -- ── Theme toggle keymaps ────────────────────────────────────────
            -- <leader>t1 → kanagawa-dragon (dark, muted – default, long sessions)
            -- <leader>t2 → kanagawa-wave   (richer colours – morning / demo mode)
            -- <leader>t3 → rose-pine-moon  (warm purple – night shift)
            local map = vim.keymap.set
            map("n", "<leader>t1", function()
                vim.cmd.colorscheme("kanagawa-dragon")
                vim.notify("kanagawa-dragon (long session)", vim.log.levels.INFO)
            end, { desc = "Theme: kanagawa-dragon (long session)" })

            map("n", "<leader>t2", function()
                vim.cmd.colorscheme("kanagawa-wave")
                vim.notify("kanagawa-wave (vivid)", vim.log.levels.INFO)
            end, { desc = "Theme: kanagawa-wave (vivid)" })

            map("n", "<leader>t3", function()
                local ok = pcall(vim.cmd.colorscheme, "rose-pine-moon")
                if not ok then
                    vim.notify("rose-pine not installed yet – run :Lazy sync", vim.log.levels.WARN)
                else
                    vim.notify("rose-pine-moon (warm night)", vim.log.levels.INFO)
                end
            end, { desc = "Theme: rose-pine-moon (warm night)" })
        end,
    },

    -- ── Tertiary: rose-pine (moon variant) ────────────────────────────────────
    -- Warm rose/purple tones. Easier on warm-tinted monitors in the evening.
    -- NOT loaded eagerly — only activated via <leader>t3 toggle.
    {
        "rose-pine/neovim",
        name   = "rose-pine",
        lazy   = true,   -- loaded on demand; kanagawa-dragon starts first
        opts   = {
            variant          = "moon",   -- moon: darkest rose-pine variant
            dark_variant     = "moon",
            dim_inactive_windows = true, -- matches kanagawa dimInactive behaviour
            extend_background_behind_borders = true,
            styles = {
                bold      = true,
                italic    = true,
                transparency = false,
            },
            -- Disable rose-pine for plugins that already have custom highlight groups
            -- so there is no flash of wrong colour on theme switch.
            disable_italics = false,
        },
        config = function(_, opts)
            require("rose-pine").setup(opts)
            -- Don't apply here – the toggle keymap (<leader>t3) applies it.
        end,
    },
}
