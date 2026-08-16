-- lua/plugins/undotree.lua
--
-- Visualizes Neovim's undo history as a TREE, not just a linear
-- stack — undoing, then making a new edit, doesn't destroy the
-- branch you undid away from; this lets you navigate back to it.
-- One command, single-purpose, so it gets its own mnemonic key
-- (<leader>u) rather than a whole prefix group.

return {
  "mbbill/undotree",
  cmd = "UndotreeToggle",
  keys = {
    { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Toggle undo tree" },
  },
  config = function()
    vim.g.undotree_SetFocusWhenToggle = 1
  end,
}