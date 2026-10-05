return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("nvim-treesitter-textobjects").setup({
      select = {
        lookahead = true, -- if cursor isn't inside a match, jump forward to the nearest one
      },
      move = {
        set_jumps = true, -- adds to the jumplist, so <C-o>/<C-i> can undo a textobject jump
      },
    })

    -- Keymaps use the SAME letters as Vim's native af/if/ib/ab
    -- conventions (f=function-ish, c=class, a=parameter/"argument")
    -- so the muscle memory transfers — we're extending native Vim
    -- text-object grammar, not inventing a new one.
    local select = require("nvim-treesitter-textobjects.select")
    local move = require("nvim-treesitter-textobjects.move")

    local map = vim.keymap.set

    map({ "x", "o" }, "af", function() select.select_textobject("@function.outer", "textobjects") end, { desc = "Around function" })
    map({ "x", "o" }, "if", function() select.select_textobject("@function.inner", "textobjects") end, { desc = "Inside function" })
    map({ "x", "o" }, "ac", function() select.select_textobject("@class.outer", "textobjects") end, { desc = "Around class" })
    map({ "x", "o" }, "ic", function() select.select_textobject("@class.inner", "textobjects") end, { desc = "Inside class" })
    map({ "x", "o" }, "aa", function() select.select_textobject("@parameter.outer", "textobjects") end, { desc = "Around parameter" })
    map({ "x", "o" }, "ia", function() select.select_textobject("@parameter.inner", "textobjects") end, { desc = "Inside parameter" })

    -- Jump to next/prev function or class start — genuinely useful in
    -- large Spring Boot controller/service files with many methods
    map("n", "]m", function() move.goto_next_start("@function.outer", "textobjects") end, { desc = "Next function start" })
    map("n", "[m", function() move.goto_previous_start("@function.outer", "textobjects") end, { desc = "Prev function start" })
    map("n", "]M", function() move.goto_next_end("@function.outer", "textobjects") end, { desc = "Next function end" })
    map("n", "[M", function() move.goto_previous_end("@function.outer", "textobjects") end, { desc = "Prev function end" })
  end,
}