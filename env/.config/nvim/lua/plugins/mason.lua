return {
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
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
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
    opts = {
      ensure_installed = {
        "gopls",         -- Go
        "rust_analyzer", -- Rust
        "pyright",       -- Python (type checking / IntelliSense)
        "ruff",          -- Python (fast linter, also does some LSP-lite actions)
        "vtsls",         -- TypeScript/JavaScript (Node)
        "jdtls",
      },
      automatic_enable = true, -- calls vim.lsp.enable() for each installed server automatically
    },
  },
  {
    -- Not "set up" directly — it ships the default server configurations
    -- (command, root_dir detection, default settings) that vim.lsp.config
    -- reads from. This is the modern role of nvim-lspconfig on 0.11+:
    -- a data source, not an imperative setup() API anymore.
    "neovim/nvim-lspconfig",
  },
}