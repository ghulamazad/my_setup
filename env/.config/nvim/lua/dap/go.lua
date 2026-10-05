-- lua/dap/go.lua
-- Problem: nvim-dap needs to know where the delve adapter binary lives.
-- delve (dlv) is installed via pacman — use it directly from PATH.
-- DO NOT use mason-registry for delve: it's a system package, not a Mason package.

require("dap").adapters.delve = {
    type = "server",
    port = "${port}",
    executable = {
        -- `dlv` is on PATH via pacman. No Mason path lookup needed.
        command = "dlv",
        args    = { "dap", "-l", "127.0.0.1:${port}" },
    },
}

require("dap").configurations.go = {
    {
        type    = "delve",
        name    = "Debug (current file)",
        request = "launch",
        program = "${file}",
    },
    {
        type    = "delve",
        name    = "Debug (package)",
        request = "launch",
        program = "${fileDirname}",
    },
    {
        type    = "delve",
        name    = "Debug test (current file)",
        request = "launch",
        mode    = "test",
        program = "${file}",
    },
    {
        -- Attach to an already-running Go process (e.g. `go run .` in a tmux pane)
        type      = "delve",
        name      = "Attach to running process",
        request   = "attach",
        mode      = "local",
        processId = require("dap.utils").pick_process,
    },
}
