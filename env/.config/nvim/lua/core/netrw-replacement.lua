-- lua/core/netrw-replacement.lua
-- Problem: `nvim .` opens nothing when netrw is disabled.
-- Solution: intercept VimEnter and open neo-tree when the argument is a directory.

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
