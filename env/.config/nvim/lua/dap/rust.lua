local codelldb_path = require("mason-registry").get_package("codelldb"):get_install_path()
  .. "/extension/adapter/codelldb"

require("dap").adapters.codelldb = {
  type = "server",
  port = "${port}",
  executable = {
    command = codelldb_path,
    args = { "--port", "${port}" },
  },
}

require("dap").configurations.rust = {
  {
    name = "Debug (cargo build)",
    type = "codelldb",
    request = "launch",
    program = function()
      -- Prompts for the compiled binary path — Rust doesn't have a
      -- single obvious "run this file" entry point the way Go does,
      -- since the binary name depends on Cargo.toml's [package] name
      vim.fn.system("cargo build")
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
  },
}