-- lua/plugins/trouble.lua
--
-- A proper list UI for diagnostics/references/quickfix, extending the
-- <leader>l diagnostics keymaps already set up in lsp/init.lua
-- (<leader>ld for line diagnostics, <leader>lD for the plain loclist).
-- This gives a nicer, filterable, project-wide diagnostics view.

return {
  "folke/trouble.nvim",
  cmd = "Trouble",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {},
  keys = {
    {
      "<leader>lt",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "LSP: toggle Trouble diagnostics",
    },
    {
      "<leader>lq",
      "<cmd>Trouble qflist toggle<cr>",
      desc = "LSP: toggle Trouble quickfix",
    },
  },
}