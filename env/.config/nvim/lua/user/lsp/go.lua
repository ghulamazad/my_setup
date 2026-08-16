vim.lsp.config("gopls", {
  settings = {
    gopls = {
      staticcheck = true,
      hints = {
        parameterNames = true,
        assignVariableTypes = true,
        compositeLiteralFields = true,
        constantValues = true,
        rangeVariableTypes = true,
      },
      analyses = {
        unusedparams = true,
        shadow = true,
      },
      usePlaceholders = true,
      completeUnimported = true,
      gofumpt = true,
    },
  },
})

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "Go-specific LSP buffer setup",
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client or client.name ~= "gopls" then
      return
    end

    vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })

    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = ev.buf,
      callback = function()
        vim.lsp.buf.format({ async = false, id = client.id })
      end,
    })
  end,
})
