-- lua/user/lsp/init.lua
--
-- Entry point for all LSP configuration. Two responsibilities:
--   1. Global <leader>l keymaps that work identically for ANY attached
--      language server (Go, Java, whatever else gets added later).
--   2. Requiring per-language config files, which handle
--      SERVER-SPECIFIC settings (gopls's staticcheck flag, jdtls's
--      JDK list, etc.) — see lsp/go.lua for that pattern.
--
-- Split this way so adding a new language later means adding one new
-- file, never touching this one.

-- ── Completion capabilities ──────────────────────────────────────
-- Tells every LSP server we start (gopls now, jdtls later) that this
-- client supports blink.cmp's completion features (snippets, etc.).
-- Must run before any server actually starts — see completion.lua for
-- why that plugin is loaded eagerly rather than on InsertEnter.
vim.lsp.config("*", {
  capabilities = require("blink.cmp").get_lsp_capabilities(),
})

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "Global LSP keymaps (any server)",
  callback = function(ev)
    local buf = ev.buf
    local opts = function(desc)
      return { buffer = buf, desc = "LSP: " .. desc }
    end
    local keymap = vim.keymap.set

    -- ── Navigation (native motions still work everywhere else —
    --    these are additive, LSP-aware jumps) ─────────────────────
    keymap("n", "gd", vim.lsp.buf.definition, opts("Go to definition"))
    keymap("n", "gD", vim.lsp.buf.declaration, opts("Go to declaration"))
    keymap("n", "gi", vim.lsp.buf.implementation, opts("Go to implementation"))
    keymap("n", "gr", vim.lsp.buf.references, opts("Go to references"))
    keymap("n", "K", vim.lsp.buf.hover, opts("Hover documentation"))

    -- ── <leader>l — LSP actions ─────────────────────────────────
    keymap("n", "<leader>lr", vim.lsp.buf.rename, opts("Rename symbol"))
    keymap(
      { "n", "v" },
      "<leader>la",
      vim.lsp.buf.code_action,
      opts("Code action")
    )
    keymap("n", "<leader>lf", function()
      vim.lsp.buf.format({ async = true })
    end, opts("Format buffer"))
    keymap("n", "<leader>ld", vim.diagnostic.open_float, opts("Line diagnostics"))
    keymap("n", "<leader>lD", vim.diagnostic.setloclist, opts("All diagnostics (loclist)"))
    keymap("n", "<leader>ls", vim.lsp.buf.signature_help, opts("Signature help"))
    keymap("n", "<leader>li", function()
      local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = buf })
      vim.lsp.inlay_hint.enable(not enabled, { bufnr = buf })
    end, opts("Toggle inlay hints"))

    -- ── Diagnostic navigation (native ]d/[d exist in newer Neovim
    --    too, but explicit is fine and matches your muscle memory
    --    better as your own deliberate mapping) ────────────────────
    keymap("n", "]d", function()
      vim.diagnostic.jump({ count = 1, float = true })
    end, opts("Next diagnostic"))
    keymap("n", "[d", function()
      vim.diagnostic.jump({ count = -1, float = true })
    end, opts("Previous diagnostic"))
  end,
})

-- ── Diagnostic display ────────────────────────────────────────────
vim.diagnostic.config({
  virtual_text = { prefix = "●" }, -- inline squiggle-adjacent marker
  severity_sort = true,
  float = { border = "rounded" },
})

-- ── Per-language configuration ────────────────────────────────────
require("user.lsp.go")
require("user.lsp.python")
require("user.lsp.rust")