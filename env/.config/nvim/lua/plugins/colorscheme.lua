return {
  "rebelot/kanagawa.nvim",
  priority = 1000, -- load before all other plugins (colors must be ready first)
  config = function()
    require("kanagawa").setup({
      compile = false, -- set true later if you want faster startup via precompiled cache
      theme = "wave",
      background = {
        dark = "wave",
        light = "lotus",
      },
      transparent = false,
      dimInactive = true, -- dims unfocused splits — helpful once we add multi-pane workflows
      terminalColors = true, -- applies the palette to :terminal too (relevant since you use tmux + nvim terminal)
      colors = {
        theme = {
          all = {
            ui = {
              bg_gutter = "none", -- sign column blends with editor bg instead of a harsh block
            },
          },
        },
      },
    })
    vim.cmd.colorscheme("kanagawa")
  end,
}