return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = "VeryLazy",
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup()

    local keymap = vim.keymap.set

    -- Add current file to the harpoon list
    keymap("n", "<leader>ha", function() harpoon:list():add() end,
      { desc = "Harpoon: add file" })

    -- Toggle the quick-menu (shows your marked files, editable as a
    -- normal buffer — delete a line to remove that mark, reorder
    -- lines to reorder the list)
    keymap("n", "<leader>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
      { desc = "Harpoon: menu" })

    -- Direct-jump to slots 1-4 — this is the actual speed win: no
    -- picker, no visual scan, just "jump to my 2nd marked file" in
    -- one keystroke combo. 1-4 covers the realistic working-set size
    -- for a single feature/task (e.g. Controller/Service/Repo/Test).
    keymap("n", "<leader>1", function() harpoon:list():select(1) end, { desc = "Harpoon file 1" })
    keymap("n", "<leader>2", function() harpoon:list():select(2) end, { desc = "Harpoon file 2" })
    keymap("n", "<leader>3", function() harpoon:list():select(3) end, { desc = "Harpoon file 3" })
    keymap("n", "<leader>4", function() harpoon:list():select(4) end, { desc = "Harpoon file 4" })

    -- Cycle through the harpoon list specifically (not all buffers —
    -- only the ones you've deliberately marked)
    keymap("n", "<C-S-P>", function() harpoon:list():prev() end, { desc = "Harpoon: prev" })
    keymap("n", "<C-S-N>", function() harpoon:list():next() end, { desc = "Harpoon: next" })
  end,
}