-- lua/core/lazy.lua
-- Problem: need a plugin manager that lazy-loads, doesn't interfere with
-- the native LSP setup, and has reproducible installs via a lock file.
-- lazy.nvim is the standard for modern Neovim configs.

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = {
        { import = "plugins" },  -- auto-loads every file in lua/plugins/*.lua
    },
    install = { colorscheme = { "kanagawa" } },
    checker  = { enabled = false },  -- no automatic update checks; use :Lazy update manually
    performance = {
        rtp = {
            -- Disable built-in plugins we don't use — shaves ~5 ms from startup.
            disabled_plugins = {
                "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin",
            },
        },
    },
    ui = { border = "rounded" },
})
