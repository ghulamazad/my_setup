-- lua/plugins/colorscheme.lua
--
-- Kanagawa WAVE variant — traditional Japanese ink-wash palette with
-- rich sumi-ink backgrounds, crystal blue and wave-aqua accents.

return {
  "rebelot/kanagawa.nvim",
  priority = 1000,
  config = function()
    require("kanagawa").setup({
      compile = false,
      undercurl = true,
      commentStyle = { italic = true },
      keywordStyle = { italic = true },
      statementStyle = { bold = true },
      typeStyle = {},
      transparent = false,
      dimInactive = false,
      terminalColors = true,
      theme = "wave",
      background = {
        dark = "wave",
        light = "lotus",
      },
    })
    vim.cmd.colorscheme("kanagawa-wave")
  end,
}