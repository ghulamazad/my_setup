-- Handles `nvim <directory>` (e.g. `nvim .`) by opening neo-tree
-- instead of blank/nothing, now that netrw is disabled (Stage 9-adjacent fix).
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local arg = vim.fn.argv(0)
    if arg ~= nil and vim.fn.isdirectory(arg) == 1 then
      vim.cmd.cd(arg)
      require("lazy").load({ plugins = { "neo-tree.nvim" } })
      vim.cmd("Neotree current dir=" .. arg)
    end
  end,
})