-- lua/plugins/harpoon.lua
--
-- Instant-jump file bookmarking. Mark the 3-4 files you're actively
-- bouncing between (e.g. a handler + its test + the interface it
-- implements) and jump to any of them with ONE keystroke — no fuzzy
-- search, no buffer list, just "give me file 2". Genuinely one of the
-- highest-value additions for active multi-file work.
--
-- Note: this is the same plugin ThePrimeagen uses, but the keybindings
-- below are our own — matching your original request to not just copy
-- his layout wholesale.

return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup()

    local keymap = vim.keymap.set

    -- ── <leader>p — project (file marks) ────────────────────────
    keymap("n", "<leader>pa", function()
      harpoon:list():add()
    end, { desc = "Project: add file to harpoon" })

    keymap("n", "<leader>ph", function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = "Project: harpoon menu" })

    -- Direct jump to marks 1-4 — this is the actual speed payoff:
    -- no picker, no search, instant switch.
    for i = 1, 4 do
      keymap("n", "<leader>p" .. i, function()
        harpoon:list():select(i)
      end, { desc = "Project: jump to harpoon " .. i })
    end
  end,
}