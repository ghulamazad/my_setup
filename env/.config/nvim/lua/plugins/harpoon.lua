-- lua/plugins/harpoon.lua
-- harpoon2: per-project file bookmarks with instant indexed access.
-- Ideal for backend work: jump between main.go, handler, service, and test
-- with a single keystroke instead of fuzzy-searching each time.
--
-- Keymaps:
--   <leader>ha  → add current file to harpoon list
--   <leader>hh  → open harpoon menu (pick/reorder/remove)
--   <C-1..4>    → jump directly to slots 1-4

return {
    {
        "ThePrimeagen/harpoon",
        branch       = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = function()
            local harpoon = require("harpoon")

            return {
                -- Add file
                {
                    "<leader>ha",
                    function() harpoon:list():add() end,
                    desc = "Harpoon: add file",
                },
                -- Open UI
                {
                    "<leader>hh",
                    function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
                    desc = "Harpoon: menu",
                },
                -- Slot 1-4: instant jump (no prefix, muscle memory target)
                {
                    "<C-1>",
                    function() harpoon:list():select(1) end,
                    desc = "Harpoon: file 1",
                },
                {
                    "<C-2>",
                    function() harpoon:list():select(2) end,
                    desc = "Harpoon: file 2",
                },
                {
                    "<C-3>",
                    function() harpoon:list():select(3) end,
                    desc = "Harpoon: file 3",
                },
                {
                    "<C-4>",
                    function() harpoon:list():select(4) end,
                    desc = "Harpoon: file 4",
                },
                -- Cycle previous/next in list (useful when list > 4)
                {
                    "<leader>h[",
                    function() harpoon:list():prev() end,
                    desc = "Harpoon: prev",
                },
                {
                    "<leader>h]",
                    function() harpoon:list():next() end,
                    desc = "Harpoon: next",
                },
            }
        end,
        config = function()
            require("harpoon"):setup({
                settings = {
                    save_on_toggle = true,
                    sync_on_ui_close = true,
                },
            })
        end,
    },
}
