-- lua/plugins/lualine.lua
--
-- Statusline: mode, git branch, diagnostics, filetype, cursor position.
-- Uses Kanagawa's built-in lualine theme so it matches the editor
-- colorscheme seamlessly.

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    options = {
      theme = "kanagawa",
      globalstatus = true, -- one statusline shared across all splits,
                            -- instead of one per split — cleaner with
                            -- multiple windows open side by side
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch", "diff" },
      lualine_c = { { "diagnostics", symbols = { error = " ", warn = " ", info = " ", hint = " " } } },
      lualine_x = { "filetype" },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
  },
}