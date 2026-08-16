-- lua/plugins/surround.lua
--
-- Add/change/delete surrounding pairs (quotes, brackets, tags) with
-- Tim Pope's community-standard mappings (ys/cs/ds) — these are
-- extensions of native Vim operator-pending motions, not new leader
-- bindings, so they fit "preserve native motions" directly.
--
-- Examples: ysiw" wraps the word under cursor in quotes.
--           cs"'  changes surrounding "quotes" to 'quotes'.
--           ds(   deletes surrounding (parens).

return {
  "kylechui/nvim-surround",
  event = "VeryLazy",
  opts = {},
}