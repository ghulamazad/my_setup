-- lua/plugins/fugitive.lua
-- vim-fugitive: gold-standard Git integration.
-- Handles: index staging, commits, branch management, diffs, log, push/pull.
-- Complements gitsigns (hunk-level work) — fugitive is for repo-level operations.

return {
    {
        "tpope/vim-fugitive",
        cmd = {
            "G", "Git", "Gdiffsplit", "Gread", "Gwrite",
            "Gclog", "GMove", "GDelete", "GBrowse",
        },
        keys = {
            -- Open the status window (like `git status` in a split)
            { "<leader>gs", "<cmd>Git<CR>",             desc = "Git status (fugitive)" },
            -- Vertical diff: index vs working tree for current file
            { "<leader>gd", "<cmd>Gdiffsplit<CR>",      desc = "Git diff split" },
            -- Commit staged changes
            { "<leader>gc", "<cmd>Git commit<CR>",       desc = "Git commit" },
            -- Amend last commit
            { "<leader>ga", "<cmd>Git commit --amend<CR>", desc = "Git amend" },
            -- Push to upstream
            { "<leader>gp", "<cmd>Git push<CR>",         desc = "Git push" },
            -- Pull (rebase by default; matches our git config pull.rebase=true)
            { "<leader>gl", "<cmd>Git pull --rebase<CR>", desc = "Git pull --rebase" },
            -- Compact log with graph
            { "<leader>gL", "<cmd>Gclog --oneline --graph --decorate -20<CR>", desc = "Git log (compact)" },
            -- Stage current file
            { "<leader>gw", "<cmd>Gwrite<CR>",           desc = "Git stage file (Gwrite)" },
        },
    },

    -- GitHub remote: :GBrowse opens current file/line on github.com
    -- Requires hub or gh CLI in PATH, or relies purely on remote URL parsing.
    {
        "tpope/vim-rhubarb",
        dependencies = { "tpope/vim-fugitive" },
    },
}
