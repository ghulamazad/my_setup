-- lua/plugins/treesitter.lua
--
-- Treesitter gives Neovim a real parse tree per buffer instead of
-- regex-guessed syntax highlighting.
--
-- NOTE ON BRANCH: nvim-treesitter's `master` branch has been formally
-- archived upstream (confirmed via its own commit log: "announce
-- archiving of master branch") — its parser-install mechanism is
-- broken, not just old. `main` is the only maintained branch, so we're
-- on it despite it having a leaner API than most tutorials assume.
-- The one known friction point (Telescope's preview highlighter) is
-- worked around in telescope.lua instead of by avoiding this branch.

local ensure_installed = {
  "go",
  "gomod",
  "gowork",
  "gosum",
  "python",
  "rust",

  "lua",
  "json",
  "yaml",
  "toml",
  "dockerfile",
  "gitcommit",
  "bash",

  "markdown",
  "markdown_inline",

  "vim",
  "vimdoc",
  "query",
}

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").install(ensure_installed)

    vim.api.nvim_create_autocmd("FileType", {
      pattern = ensure_installed,
      callback = function(ev)
        local ok = pcall(vim.treesitter.start, ev.buf)
        if ok then
          vim.bo[ev.buf].indentexpr = "v:lua.vim.treesitter.indentexpr()"
        end
      end,
    })
  end,
}