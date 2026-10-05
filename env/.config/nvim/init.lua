-- ~/.config/nvim/init.lua
-- Entry point. Loads are ordered intentionally:
--   1. options/keymaps/diagnostics  (pure vim.opt/vim.keymap calls, no plugins needed)
--   2. LSP configs                  (vim.lsp.config calls; safe before lazy because nvim 0.11)
--   3. lazy.nvim                    (plugin manager bootstraps and imports lua/plugins/*)
--   4. netrw-replacement            (VimEnter autocmd; must be after lazy so neo-tree exists)

require("core.options")
require("core.keymaps")
require("core.diagnostics")
require("core.lsp")
require("lsp.go")
require("lsp.rust")
require("lsp.python")
require("lsp.node")
require("lsp.cpp")   -- clangd: Mason installs the binary; this file sets settings
require("core.lazy")
require("core.netrw-replacement")
