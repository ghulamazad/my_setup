-- lua/dap/rust.lua
-- codelldb: owned by Mason (no pacman package for the nvim-dap adapter).
-- Uses the Mason-installed codelldb binary path.

local codelldb_path = require("mason-registry").get_package("codelldb"):get_install_path()
    .. "/extension/adapter/codelldb"

require("dap").adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
        command = codelldb_path,
        args    = { "--port", "${port}" },
    },
}

require("dap").configurations.rust = {
    {
        name    = "Debug (cargo build)",
        type    = "codelldb",
        request = "launch",
        program = function()
            -- Rust doesn't have a single entry point per file; binary name comes from Cargo.toml.
            vim.fn.system("cargo build")
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
        end,
        cwd         = "${workspaceFolder}",
        stopOnEntry = false,
    },
}
