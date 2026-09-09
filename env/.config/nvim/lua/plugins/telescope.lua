return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  cmd = "Telescope", -- lazy-load: only loads when you actually invoke it
  dependencies = {
    "nvim-lua/plenary.nvim", -- utility library Telescope is built on
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make", -- compiles the native C matcher on install
    },
    "nvim-tree/nvim-web-devicons", -- file-type icons in results (you have the Nerd Font for this)
  },

  keys = {
    -- Deliberately grouped under <leader>f ("find") — consistent
    -- prefix makes it easy to remember/discover the whole group
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep (search text)" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffers" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
    { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
    { "<leader>fw", "<cmd>Telescope grep_string<cr>", desc = "Grep word under cursor" },

    -- Git integration — pulls from git status/log, no separate plugin needed for this part
    { "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Git status" },
    { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Git commits" },
    { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Git branches" },

    -- LSP-powered searches — these query the LSP servers we set up in
    -- Stage 2-4, so results are semantically accurate (not text-grep)
    { "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document symbols" },
    { "<leader>fS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Workspace symbols" },
    { "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics (all buffers)" },
  },

  -- lua/plugins/telescope.lua  (add `preview` under `defaults` in opts)
  opts = {
    defaults = {
      prompt_prefix = "  ",
      selection_caret = " ",
      path_display = { "truncate" },
      sorting_strategy = "ascending",
      layout_config = {
        prompt_position = "top",
      },
      file_ignore_patterns = {
        "%.git/",
        "target/",
        "node_modules/",
        "%.class$",
      },
      mappings = {
        i = {
          ["<C-j>"] = "move_selection_next",
          ["<C-k>"] = "move_selection_previous",
          ["<Esc>"] = "close",
        },
      },

      -- Telescope's previewer calls a legacy nvim-treesitter API
      -- (`ft_to_lang`) that no longer exists on the treesitter "main"
      -- branch we're using — disabling treesitter specifically in the
      -- preview pane avoids the crash. Regular buffer highlighting
      -- elsewhere is completely unaffected; this only touches the
      -- small preview window inside the picker.
      preview = {
        treesitter = false,
      },
    },
    extensions = {
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = "smart_case",
      },
    },
  },

  config = function(_, opts)
    require("telescope").setup(opts)
    require("telescope").load_extension("fzf")
  end,
}