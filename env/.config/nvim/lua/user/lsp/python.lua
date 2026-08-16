-- lua/user/lsp/python.lua
--
-- Two servers, deliberately split by responsibility:
--   pyright -> type-checking, hover, go-to-definition, completion
--   ruff    -> linting + formatting (fast, Rust-based; the modern
--              replacement for flake8/black/isort as one tool)
--
-- Both attach to the same buffer at once. A couple of small overlaps
-- need resolving below (hover shows twice otherwise; format-on-save
-- should only ever run through ruff, never pyright, since pyright
-- doesn't format at all and would no-op or error if asked to).

vim.lsp.config("pyright", {
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "basic", -- "strict" is available if you
                                     -- want stricter type enforcement
                                     -- later; "basic" is the sane
                                     -- starting point for a fresh setup
        autoImportCompletions = true,

        -- Inlay hints — same IntelliJ-style ask as Go's parameterNames,
        -- Python side.
        inlayHints = {
          variableTypes = true,
          functionReturnTypes = true,
          callArgumentNames = true,
        },
      },
    },
  },
})

vim.lsp.config("ruff", {
  init_options = {
    settings = {
      -- ruff intentionally does NOT handle type checking (that's
      -- pyright's job) — this keeps its scope to linting/formatting
      -- only, avoiding duplicate/conflicting diagnostics between the
      -- two servers.
      lint = { enable = true },
    },
  },
})

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "Python-specific LSP buffer setup",
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then
      return
    end

    if client.name == "pyright" then
      vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
    end

    if client.name == "ruff" then
      -- pyright's hover documentation is richer (shows inferred types
      -- alongside docstrings) — disable ruff's own hover so you don't
      -- get two competing hover popups on the same keypress.
      client.server_capabilities.hoverProvider = false

      -- Format-on-save runs through ruff specifically, not "whichever
      -- client responds first" — pyright doesn't implement formatting
      -- at all, so this filter is what guarantees the right tool runs.
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = ev.buf,
        callback = function()
          vim.lsp.buf.format({
            async = false,
            filter = function(c)
              return c.name == "ruff"
            end,
          })
        end,
      })
    end
  end,
})