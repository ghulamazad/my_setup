-- lua/plugins/dap-rust.lua
--
-- Rust has no dedicated "nvim-dap-rust" plugin the way Go and Python
-- do — instead, we configure nvim-dap's core (dap.lua) directly with
-- codelldb (Mason-installed above) as the adapter. `cargo test` output
-- parsing for "debug the test under my cursor" isn't as turnkey as
-- Go/Python's Treesitter-based detection, so the test path here runs
-- `cargo test` in a plain terminal — reliable, if not automatically
-- debugger-attached. Debugging a specific binary IS fully wired below.

return {
  "mfussenegger/nvim-dap",
  ft = "rust",
  config = function()
    local dap = require("dap")
    local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"

    dap.adapters.codelldb = {
      type = "server",
      port = "${port}",
      executable = {
        command = mason_bin .. "/codelldb",
        args = { "--port", "${port}" },
      },
    }

    dap.configurations.rust = {
      {
        name = "Debug binary",
        type = "codelldb",
        request = "launch",
        program = function()
          -- Prompts for the compiled binary path — typically
          -- target/debug/<crate-name> after `cargo build`.
          return vim.fn.input("Path to binary: ", vim.fn.getcwd() .. "/target/debug/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
      },
    }

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "rust",
      callback = function(ev)
        local buf = ev.buf
        local desc = function(d)
          return { buffer = buf, desc = "Test: " .. d }
        end

        vim.keymap.set("n", "<leader>tp", function()
          -- cd into the current FILE's directory (not Neovim's global
          -- cwd, which may not match) — cargo walks upward from there
          -- to find Cargo.toml on its own.
          local file_dir = vim.fn.expand("%:p:h")
          vim.cmd("split | terminal cd " .. vim.fn.shellescape(file_dir) .. " && cargo test")
        end, desc("run project tests (no debugger)"))
      end,
    })
  end,
}