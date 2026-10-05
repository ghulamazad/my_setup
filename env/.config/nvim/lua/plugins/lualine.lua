-- lua/plugins/lualine.lua
-- lualine: fast, declarative statusline.
-- Theme: kanagawa (matches colorscheme; will gracefully degrade if not loaded yet
-- because lualine resolves theme strings at render time, not at setup time).
--
-- Sections:
--   left  → mode | git branch | diagnostics (errors first) | diff signs
--   right → LSP client name | filetype | encoding | file position

return {
    {
        "nvim-lualine/lualine.nvim",
        event        = "VeryLazy",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            options = {
                -- Follow the active colorscheme automatically.
            -- When you switch via <leader>t1/t2/t3, lualine re-renders correctly.
            theme                = "auto",
                component_separators = { left = "", right = "" },
                section_separators   = { left = "", right = "" },
                globalstatus         = true,   -- one statusline for all windows
                disabled_filetypes   = {
                    statusline = { "neo-tree", "dashboard", "alpha" },
                },
            },
            sections = {
                lualine_a = { "mode" },

                lualine_b = {
                    {
                        "branch",
                        icon = "",
                    },
                    {
                        "diff",
                        symbols = { added = " ", modified = " ", removed = " " },
                        colored = true,
                    },
                },

                lualine_c = {
                    {
                        "filename",
                        path     = 1,   -- show relative path
                        symbols  = { modified = "●", readonly = "", unnamed = "[No Name]" },
                    },
                    {
                        "diagnostics",
                        sources  = { "nvim_lsp" },
                        sections = { "error", "warn", "info", "hint" },
                        symbols  = { error = " ", warn = " ", info = " ", hint = " " },
                        always_visible = false,
                    },
                },

                lualine_x = {
                    -- Active LSP client(s) for the current buffer
                    {
                        function()
                            local clients = vim.lsp.get_clients({ bufnr = 0 })
                            if #clients == 0 then return "" end
                            local names = {}
                            for _, c in ipairs(clients) do
                                -- skip null-ls / conform virtual clients
                                if c.name ~= "null-ls" and c.name ~= "copilot" then
                                    names[#names + 1] = c.name
                                end
                            end
                            return #names > 0 and ("󰒍 " .. table.concat(names, ", ")) or ""
                        end,
                        color = { fg = "#7fb4ca" },   -- kanagawa spring-blue
                    },
                    "encoding",
                    "fileformat",
                    "filetype",
                },

                lualine_y = { "progress" },
                lualine_z = { "location" },
            },

            inactive_sections = {
                lualine_c = { { "filename", path = 1 } },
                lualine_x = { "location" },
            },

            extensions = { "neo-tree", "fugitive", "quickfix", "lazy", "mason" },
        },
    },
}
