vim.lsp.config("gopls", {
  settings = {
    gopls = {
      -- staticcheck is a stricter linter than gopls' built-in analysis
      -- (catches more real bugs: unused struct fields, etc.)
      staticcheck = true,

      -- Inlay hints: parameter names + inferred types. Off globally by
      -- default (Stage 2's toggle), but when you DO turn it on, these
      -- sub-flags control exactly which hints appear — kept minimal
      -- and useful rather than showing everything gopls can show.
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        constantValues = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },

      -- Organizes imports automatically as part of gofumpt-style formatting
      gofumpt = true, -- stricter superset of gofmt — catches more style issues

      -- Enables gopls' built-in "unused parameter/variable" analysis
      analyses = {
        unusedparams = true,
        shadow = true,
      },

      usePlaceholders = true, -- function args become tab-stops on completion
    },
  },
})

-- gofmt/goimports on save — native autocmd, no plugin needed.
-- We use LSP formatting (gopls implements gofumpt) rather than a
-- separate formatter runner, since gopls already does this correctly.
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})