return {
  "tpope/vim-fugitive",
  cmd = { "Git", "Gvsplit", "Gsplit", "Gedit", "Gdiffsplit", "Gread", "Gwrite", "GBrowse" },
  keys = {
    { "<leader>gg", "<cmd>Git<cr>", desc = "Git status (fugitive)" },
    { "<leader>gd", "<cmd>Gdiffsplit<cr>", desc = "Git diff (current file)" },
    { "<leader>gB", "<cmd>Git blame<cr>", desc = "Git blame (full file)" },
    { "<leader>gp", "<cmd>Git push<cr>", desc = "Git push" },
    { "<leader>gP", "<cmd>Git pull<cr>", desc = "Git pull" },
    { "<leader>gl", "<cmd>Git log --oneline<cr>", desc = "Git log" },
  },
}