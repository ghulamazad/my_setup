return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy", -- loads after everything else, statusline isn't needed on the very first frame
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    options = {
      theme = "kanagawa", -- lualine ships a native kanagawa theme, matches Stage 1 exactly
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      globalstatus = true, -- one statusline for all splits (matches laststatus=3 from Stage 0)
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch" }, -- git branch, works standalone, no gitsigns dependency needed here
      lualine_c = {
        { "filename", path = 1 }, -- path=1 shows relative path, useful when multiple files share a name (common in Java package structures)
      },
      lualine_x = {
        -- Shows attached LSP client names — quick sanity check that
        -- e.g. jdtls or gopls is actually attached, without running :LspInfo
        {
          function()
            local clients = vim.lsp.get_clients({ bufnr = 0 })
            if #clients == 0 then
              return ""
            end
            local names = {}
            for _, c in ipairs(clients) do
              table.insert(names, c.name)
            end
            return " " .. table.concat(names, ", ")
          end,
        },
        "encoding",
        "filetype",
      },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
  },
}