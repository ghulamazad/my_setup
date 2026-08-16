-- lua/plugins/dap-python.lua
--
-- nvim-dap-python wires debugpy (Python's standard debugger, same one
-- VSCode's Python extension uses) into the nvim-dap core from dap.lua.
-- debugpy itself is installed via Mason (below) rather than pip, to
-- keep it isolated from any project-specific virtualenv — this is a
-- debugger for the EDITOR to use, not a project dependency.

return {
  "mfussenegger/nvim-dap-python",
  ft = "python",
  dependencies = {
    "mfussenegger/nvim-dap",
    "rcarriga/nvim-dap-ui",
  },
  config = function()
    -- Mason installs debugpy's own isolated venv here.
    local debugpy_path = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
    require("dap-python").setup(debugpy_path)

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "python",
      callback = function(ev)
        local buf = ev.buf
        local desc = function(d)
          return { buffer = buf, desc = "Test: " .. d }
        end

        -- Same buffer-local-keymap pattern as dap-go.lua — see that
        -- file's comment for why this matters (prevents keymap
        -- collisions between languages).
        vim.keymap.set("n", "<leader>tt", function()
          require("dap-python").test_method()
        end, desc("debug nearest (pytest)"))

        vim.keymap.set("n", "<leader>tc", function()
          require("dap-python").test_class()
        end, desc("debug whole class (pytest)"))

        vim.keymap.set("n", "<leader>tp", function()
          vim.cmd("split | terminal python -m pytest")
        end, desc("run project tests (no debugger)"))
      end,
    })
  end,
}