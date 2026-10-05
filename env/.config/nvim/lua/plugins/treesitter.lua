return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },

  opts = {
    ensure_installed = {
      "go", "gomod", "gowork", "gosum",
      "java",
      "rust",
      "python",
      "javascript", "typescript", "tsx",
      "lua",
      "bash",
      "json", "yaml", "toml",
      "dockerfile",
      "sql",
      "markdown", "markdown_inline",
      "gitcommit", "git_rebase", "diff",
    },
    auto_install = true,

    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    indent = {
      enable = true,
      disable = { "python" },
    },
  },

  config = function(_, opts)
    require("nvim-treesitter").setup(opts)

    -- The "main" branch doesn't auto-install ensure_installed on
    -- setup() the way the old branch did — we trigger it explicitly
    -- here so a fresh clone of this config installs every required
    -- parser on first launch, not just whichever filetype you
    -- happen to open first (which is what auto_install alone covers).
    local installed = require("nvim-treesitter.config").installed_parsers and
      require("nvim-treesitter.config").installed_parsers() or {}

    local to_install = vim.tbl_filter(function(lang)
      return not vim.tbl_contains(installed, lang)
    end, opts.ensure_installed)

    if #to_install > 0 then
      require("nvim-treesitter").install(to_install)
    end
  end,
}