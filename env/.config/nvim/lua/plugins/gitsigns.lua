-- lua/plugins/gitsigns.lua
-- gitsigns.nvim: gutter hunk signs, inline blame, and hunk-level staging.
-- Complements fugitive (which handles commits, diffs, log).
-- gitsigns does: hunk navigation, stage/reset individual hunks, blame.
-- fugitive does: index staging, commit, push, branch management, :Glog.

return {
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts  = {
            -- ── Signs ─────────────────────────────────────────────────────────
            signs = {
                add          = { text = "▎" },
                change       = { text = "▎" },
                delete       = { text = "" },
                topdelete    = { text = "" },
                changedelete = { text = "▎" },
                untracked    = { text = "▎" },
            },
            signs_staged = {
                add          = { text = "▎" },
                change       = { text = "▎" },
                delete       = { text = "" },
                topdelete    = { text = "" },
                changedelete = { text = "▎" },
            },

            -- ── Blame ──────────────────────────────────────────────────────────
            -- Inline blame shown after cursor-hold. Toggle with <leader>gb.
            current_line_blame = false,  -- off by default (can be noisy)
            current_line_blame_opts = {
                virt_text         = true,
                virt_text_pos     = "eol",
                delay             = 800,
                ignore_whitespace = true,
            },
            current_line_blame_formatter = " <author>, <author_time:%Y-%m-%d> • <summary>",

            -- ── Keymaps ───────────────────────────────────────────────────────
            on_attach = function(bufnr)
                local gs  = require("gitsigns")
                local map = function(mode, lhs, rhs, desc)
                    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
                end

                -- Hunk navigation (wraps at file boundaries)
                map("n", "]h", function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "]c", bang = true })
                    else
                        gs.nav_hunk("next")
                    end
                end, "Next hunk")
                map("n", "[h", function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "[c", bang = true })
                    else
                        gs.nav_hunk("prev")
                    end
                end, "Prev hunk")

                -- Stage / reset
                map("n", "<leader>hs", gs.stage_hunk,       "Stage hunk")
                map("n", "<leader>hr", gs.reset_hunk,       "Reset hunk")
                map("n", "<leader>hS", gs.stage_buffer,     "Stage buffer")
                map("n", "<leader>hR", gs.reset_buffer,     "Reset buffer")
                map("n", "<leader>hu", gs.undo_stage_hunk,  "Undo stage hunk")

                -- Visual mode: stage/reset only the selected lines
                map("v", "<leader>hs", function()
                    gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, "Stage selected lines")
                map("v", "<leader>hr", function()
                    gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, "Reset selected lines")

                -- Preview / diff
                map("n", "<leader>hp", gs.preview_hunk,          "Preview hunk")
                map("n", "<leader>hd", gs.diffthis,              "Diff this file")
                map("n", "<leader>hD", function() gs.diffthis("~") end, "Diff against HEAD~1")

                -- Blame
                map("n", "<leader>gb", gs.toggle_current_line_blame, "Toggle line blame")
                map("n", "<leader>gB", gs.blame,                     "Full file blame")

                -- Text objects: operate on hunk as motion target
                map({ "o", "x" }, "ih", gs.select_hunk, "Select hunk")
            end,
        },
    },
}
