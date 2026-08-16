-- lua/plugins/which-key.lua
--
-- Shows a popup of available keybindings as you type a <leader>
-- sequence and pause. With the number of semantic prefixes this
-- config has grown (f/s/g/l/d/t/b/p), this turns "which key was it
-- again?" into something you can just look at instead of guessing.

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "modern",
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)

    -- Group labels for the popup — matches the semantic prefix legend
    -- from the very start of this config.
    wk.add({
      { "<leader>f", group = "find" },
      { "<leader>s", group = "search" },
      { "<leader>g", group = "git" },
      { "<leader>l", group = "lsp" },
      { "<leader>D", group = "debug" },
      { "<leader>t", group = "test" },
      { "<leader>b", group = "buffer" },
      { "<leader>p", group = "project" },
    })
  end,
}