-- lua/plugins/dap-go.lua
--
-- nvim-dap-go wires Delve (dlv, installed as a prerequisite) into the
-- nvim-dap core from dap.lua, and can detect the test function your
-- cursor is inside via Treesitter to debug just that one.
--
-- IMPORTANT: keymaps are set via a buffer-local FileType autocommand,
-- NOT lazy.nvim's `keys` field. lazy.nvim's `keys` registers globally
-- the moment the plugin loads — it does NOT scope the keymap itself to
-- Go buffers, only WHEN the plugin loads. That caused a real bug: the
-- global <leader>tt leaked into Java buffers and shadowed jdtls's own
-- test keymap. Buffer-local keymaps (this file's approach, and
-- lsp/java.lua's) are the correct way to keep per-language keymaps
-- from colliding when multiple language plugins are loaded in the
-- same session.

return {
  "leoluz/nvim-dap-go",
  ft = "go",
  dependencies = { "mfussenegger/nvim-dap" },
  opts = {},
  config = function(_, opts)
    require("dap-go").setup(opts)

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "go",
      callback = function(ev)
        local buf = ev.buf
        local desc = function(d)
          return { buffer = buf, desc = "Test: " .. d }
        end

        vim.keymap.set("n", "<leader>tt", function()
          require("dap-go").debug_test()
        end, desc("debug nearest (under cursor)"))

        vim.keymap.set("n", "<leader>tl", function()
          require("dap-go").debug_last_test()
        end, desc("debug last run"))

        vim.keymap.set("n", "<leader>tp", function()
          vim.cmd("split | terminal go test ./...")
        end, desc("run current package (no debugger)"))

        vim.keymap.set("n", "<leader>ta", function()
          vim.cmd("split | terminal go test ./... -v")
        end, desc("run all, verbose (no debugger)"))
      end,
    })
  end,
}