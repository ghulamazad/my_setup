return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  cmd = "Neotree", -- lazy-load on first use of the :Neotree command
  keys = {
    {
      "<leader>pe",
      "<cmd>Neotree toggle reveal<cr>",
      desc = "Project: toggle Explorer",
    },
  },
  opts = {
    close_if_last_window = true, -- don't leave a lone neo-tree window
                                  -- open after closing every real buffer
    filesystem = {
      follow_current_file = {
        enabled = true, -- tree auto-scrolls/highlights whatever file
                         -- you have open — useful when jumping via the
                         -- fuzzy finder and wanting to see it in context
      },
      hijack_netrw_behavior = "open_default", -- neo-tree replaces netrw
                                               -- (Neovim's built-in, more
                                               -- primitive explorer)
      filtered_items = {
        visible = false,        -- hide dotfiles/gitignored by default...
        hide_dotfiles = false,  -- ...except don't hide dotfiles, since
        hide_gitignored = true, -- Go/Java projects have relevant dotfiles
                                 -- (.golangci.yml, .editorconfig, etc.)
      },
    },
    window = {
      width = 32,
      mappings = {
        ["<space>"] = "none", -- we use space as <leader> globally;
                               -- don't let neo-tree also bind it locally
      },
    },
  },
}