-- lua/plugins/mason.lua
--
-- Mason is a package manager LIVING INSIDE Neovim for dev tooling:
-- LSP servers, formatters, linters, debug adapters. It installs into
-- ~/.local/share/nvim/mason/, completely separate from your system
-- $PATH (your existing `go install`'d gopls, for example, is
-- untouched — Mason keeps its own copy).
--
-- Why bother, given gopls is already on your system: reproducibility.
-- This config becomes self-contained — clone your dotfiles onto a new
-- machine, open Neovim, and every tool it needs installs itself with
-- pinned, known-good versions, rather than you remembering a list of
-- `go install` / `dnf install` commands you ran six months ago.

return {
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },
  {
    -- Bridges Mason-installed servers to Neovim's native LSP client.
    -- Without this you'd have to manually pass each server's exact
    -- binary path from Mason's install dir into your LSP config by
    -- hand — this does that wiring for you.
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      -- Used here purely as a DATA SOURCE of known-good default
      -- server configs (the actual gopls/rust-analyzer/pyright
      -- settings we write in their own lsp/*.lua files layer on top
      -- of these). We are NOT using its old
      -- require("lspconfig").setup() API — that's superseded by
      -- Neovim 0.11+'s native vim.lsp.config/vim.lsp.enable, which
      -- automatic_enable below calls into directly.
      "neovim/nvim-lspconfig",
    },
    opts = {
      -- We install servers EXPLICITLY here rather than letting this
      -- auto-install whatever LSP config gets referenced — keeps the
      -- tool list intentional and visible in one place, matching the
      -- "small number of deliberate choices" philosophy for this config.
      ensure_installed = {
        "gopls", -- Go
        "pyright", -- Python: type-checking, completion, hover, go-to-def
        "ruff", -- Python: fast linting + formatting (separate from pyright
                -- on purpose — different job, different tool)
        "rust_analyzer", -- Rust: LSP + built-in formatting (rustfmt),
                          -- no separate formatter tool needed
      },
      automatic_enable = true, -- once installed, automatically call
                                -- vim.lsp.enable() for it — safe as a
                                -- blanket default as long as every
                                -- server here uses the plain
                                -- static-config pattern (Go, Rust,
                                -- Python all do — none of them need
                                -- jdtls-style custom per-project
                                -- launch logic)
    },
  },
  {
    -- debugpy isn't an LSP server, so mason-lspconfig's ensure_installed
    -- above silently ignores it — this handles non-LSP-server tools
    -- instead (the same role this plugin played for jdtls before Java
    -- was removed from this config).
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = { "debugpy", "codelldb" },
    },
  },
}