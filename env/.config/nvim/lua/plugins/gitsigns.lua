-- lua/plugins/gitsigns.lua
--
-- Gutter-level git integration: shows added/changed/deleted lines as
-- you edit (signcolumn is already reserved for this — see options.lua),
-- with keymaps to stage/reset/preview individual hunks without leaving
-- the buffer, plus inline blame on demand.

return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" }, -- load whenever you open any
                                           -- file, not just inside a
                                           -- git repo (gitsigns itself
                                           -- checks and no-ops outside one)
  opts = {
    signs = {
      add = { text = "│" },
      change = { text = "│" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
    },
    current_line_blame = false, -- off by default (can be noisy) —
                                 -- toggle on demand with <leader>gb
    current_line_blame_opts = {
      delay = 300,
    },
    on_attach = function(bufnr)
      local gs = require("gitsigns")
      local keymap = vim.keymap.set
      local opts = function(desc)
        return { buffer = bufnr, desc = "Git: " .. desc }
      end

      -- ── Hunk navigation ──────────────────────────────────────
      -- ]c / [c is the long-standing Vim convention for "change" —
      -- staying consistent with existing muscle memory rather than
      -- inventing a new pair of keys.
      keymap("n", "]c", function()
        gs.nav_hunk("next")
      end, opts("Next hunk"))
      keymap("n", "[c", function()
        gs.nav_hunk("prev")
      end, opts("Previous hunk"))

      -- ── <leader>g — git actions on the current hunk/file ────
      keymap("n", "<leader>gs", gs.stage_hunk, opts("Stage hunk"))
      keymap("n", "<leader>gr", gs.reset_hunk, opts("Reset hunk"))
      keymap("v", "<leader>gs", function()
        gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, opts("Stage selected lines"))
      keymap("v", "<leader>gr", function()
        gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, opts("Reset selected lines"))
      keymap("n", "<leader>gp", gs.preview_hunk, opts("Preview hunk"))
      keymap("n", "<leader>gu", gs.undo_stage_hunk, opts("Undo stage hunk"))
      keymap("n", "<leader>gb", gs.toggle_current_line_blame, opts("Toggle line blame"))
      keymap("n", "<leader>gd", gs.diffthis, opts("Diff this file"))
    end,
  },
}