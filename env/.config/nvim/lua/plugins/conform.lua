return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" }, -- loads right before you save a file, not before
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>cf",
        function() require("conform").format({ async = true, lsp_fallback = true }) end,
        desc = "Format buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        rust = { "rustfmt" },
        python = { "ruff_format" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        lua = { "stylua" },
      },
      format_on_save = function(bufnr)
      -- Go is skipped because gopls already auto-formats it (Stage 3).
      if vim.bo[bufnr].filetype == "go" then
        return nil
      end
      return { timeout_ms = 500, lsp_fallback = true }
    end,
        },
  },
  {
    -- This second entry just installs the actual formatter programs
    -- (rustfmt, prettier, stylua) via Mason, same way Mason installs
    -- your LSP servers. Without this, conform has nothing to run.
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = { "prettier", "stylua" },
    },
  },
}