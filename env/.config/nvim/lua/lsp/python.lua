vim.lsp.config("pyright", {
  settings = {
    pyright = {
      -- Let ruff own diagnostics entirely — avoids duplicate warnings
      disableOrganizeImports = true,
    },
    python = {
      analysis = {
        typeCheckingMode = "basic", -- "strict" is available if you want it later
        autoImportCompletions = true,
      },
    },
  },
})

vim.lsp.config("ruff", {
  init_options = {
    settings = {
      -- ruff handles linting; we let it organize imports too since
      -- pyright's own import-organizer is disabled above
      organizeImports = true,
    },
  },
})