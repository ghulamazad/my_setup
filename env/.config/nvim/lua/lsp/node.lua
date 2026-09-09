vim.lsp.config("vtsls", {
  settings = {
    typescript = {
      inlayHints = {
        parameterNames = { enabled = "literals" }, -- only for literal args, less noisy
        variableTypes = { enabled = false },
        propertyDeclarationTypes = { enabled = false },
      },
      updateImportsOnFileMove = { enabled = "always" },
    },
    javascript = {
      inlayHints = {
        parameterNames = { enabled = "literals" },
      },
    },
  },
})