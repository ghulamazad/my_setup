-- lua/plugins/lazygit.lua
--
-- Rather than a Neovim plugin trying to reimplement a git UI, this
-- shells out to the real `lazygit` TUI you already know, in a floating
-- window. Minimal plugin surface, full LazyGit functionality, and
-- gitsigns automatically refreshes its gutter signs once you close it
-- (since LazyGit exiting just returns you to the same buffer).

return {
  "kdheepak/lazygit.nvim",
  cmd = {
    "LazyGit",
    "LazyGitConfig",
    "LazyGitCurrentFile",
    "LazyGitFilter",
  },
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>gg", "<cmd>LazyGit<cr>", desc = "Git: open LazyGit" },
    {
      "<leader>gf",
      "<cmd>LazyGitCurrentFile<cr>",
      desc = "Git: LazyGit filtered to current file",
    },
  },
}