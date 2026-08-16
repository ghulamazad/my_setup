-- lua/user/lsp/rust.lua
--
-- rust-analyzer is the single well-behaved server here: it handles
-- LSP features AND formatting (rustfmt is invoked internally, no
-- separate formatter plugin needed) AND has excellent inlay hints
-- support out of the box.

vim.lsp.config("rust_analyzer", {
  settings = {
    ["rust-analyzer"] = {
      check = {
        command = "clippy", -- run clippy (Rust's stricter linter) as
                             -- the on-save/on-type check, instead of
                             -- plain `cargo check` — same "start
                             -- strict" reasoning as gofumpt for Go
      },
      inlayHints = {
        parameterHints = { enable = true },
        typeHints = { enable = true },
        chainingHints = { enable = true }, -- shows inferred types on
                                            -- chained method calls,
                                            -- e.g. .iter().map(...) —
                                            -- particularly useful in Rust
      },
    },
  },
})

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "Rust-specific LSP buffer setup",
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client or client.name ~= "rust_analyzer" then
      return
    end

    vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })

    -- rust-analyzer's formatting IS rustfmt — no separate tool/filter
    -- needed here, unlike Python's pyright+ruff split.
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = ev.buf,
      callback = function()
        vim.lsp.buf.format({ async = false, id = client.id })
      end,
    })
  end,
})