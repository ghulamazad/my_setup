vim.lsp.config("rust_analyzer", {
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true, -- analyze code behind feature flags too, not just default
        loadOutDirsFromCheck = true,
      },
      checkOnSave = true,
      check = {
        command = "clippy", -- run clippy instead of plain `cargo check` — catches more
      },
      inlayHints = {
        bindingModeHints = { enable = false }, -- these get noisy fast, keep off
        closureReturnTypeHints = { enable = "with_block" },
        lifetimeElisionHints = { enable = "skip_trivial" },
      },
    },
  },
})