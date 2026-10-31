return {
    "tiagovla/tokyodark.nvim",
    opts = {
    },
    config = function(_, opts)
        require("tokyodark").setup(opts) 
        vim.cmd [[colorscheme tokyodark]]
    end,
}

-- return {
--     {
--         "olimorris/onedarkpro.nvim",
--         priority = 1000, -- Load the colorscheme first
--         config = function()
--             vim.cmd("colorscheme onedark")
--         end,
--     },
-- }
