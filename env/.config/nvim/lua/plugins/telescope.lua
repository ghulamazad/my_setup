-- lua/plugins/telescope.lua
--
-- Telescope: fuzzy finder over files, text, and just about anything else
-- a plugin wants to expose as a "list of things to pick from" (LSP
-- symbols, git branches, DAP breakpoints, etc. in later stages).
--
-- Split into two prefixes per your scheme:
--   <leader>f = find something BY NAME  (files, buffers, recent files)
--   <leader>s = search something BY CONTENT (grep, word under cursor)

return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      -- Compiled C sorter — this is what closes most of the performance
      -- gap with fzf-lua. Requires `make` (installed as a prerequisite).
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
    "nvim-tree/nvim-web-devicons",
  },
  cmd = "Telescope",
  keys = {
    -- ── <leader>f — find (by name) ──────────────────────────────
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find: files" },
    { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Find: recent files" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find: buffers" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Find: help" },
    { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Find: keymaps" },

    -- ── <leader>s — search (by content) ─────────────────────────
    { "<leader>ss", "<cmd>Telescope live_grep<cr>", desc = "Search: text (grep)" },
    { "<leader>sw", "<cmd>Telescope grep_string<cr>", desc = "Search: word under cursor" },
    { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Search: in buffer" },
    { "<leader>sd", "<cmd>Telescope diagnostics<cr>", desc = "Search: diagnostics" },
    { "<leader>sr", "<cmd>Telescope resume<cr>", desc = "Search: resume last" },
  },
  config = function()
    local telescope = require("telescope")

    telescope.setup({
      defaults = {
        prompt_prefix = "  ",
        selection_caret = " ",
        sorting_strategy = "ascending", -- results top-to-bottom, prompt at
                                         -- the top — reads more naturally
                                         -- than Telescope's default bottom-up
        layout_config = {
          prompt_position = "top",
        },
        preview = {
          -- nvim-treesitter's `main` branch (which we use — see
          -- treesitter.lua) removed the module Telescope's preview
          -- highlighter depends on. Disabling this avoids a crash on
          -- <leader>ff; the preview pane still shows file content,
          -- just without treesitter-specific highlighting in the
          -- preview window specifically.
          treesitter = false,
        },
        -- Standard "don't search this junk" ignore list. Extend per-project
        -- later via .gitignore respect (on by default) rather than hardcoding
        -- more here.
        file_ignore_patterns = { "%.git/", "node_modules/", "target/", "bin/" },
      },
    })

    -- Load the compiled sorter. Wrapped in pcall so a fresh install
    -- (before `make` has run) doesn't throw an error on startup.
    pcall(telescope.load_extension, "fzf")
  end,
}