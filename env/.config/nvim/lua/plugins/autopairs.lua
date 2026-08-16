-- lua/plugins/autopairs.lua
--
-- Auto-closes brackets/quotes/parens as you type. No explicit
-- integration code needed with blink.cmp specifically — that's an
-- nvim-cmp-only requirement (nvim-autopairs ships a dedicated
-- nvim-cmp glue module we're not using). autopairs just listens to
-- raw insert-mode character events, which happens correctly
-- regardless of what triggered the insertion — typing directly or
-- accepting a completion both just look like text being inserted.

return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  opts = {},
}