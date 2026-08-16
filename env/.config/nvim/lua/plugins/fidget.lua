-- lua/plugins/fidget.lua
--
-- Shows LSP progress notifications (indexing, analyzing, etc.) as a
-- small, unobtrusive corner popup. Solves a real gap: without this,
-- "rust-analyzer is still indexing" and "rust-analyzer is broken" look
-- identical — you just get empty hover/definition results either way.

return {
  "j-hui/fidget.nvim",
  event = "LspAttach",
  opts = {},
}