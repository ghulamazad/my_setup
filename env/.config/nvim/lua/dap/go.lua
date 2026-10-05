require("dap").adapters.delve = {
	type = "server",
	port = "${port}",
	executable = {
		command = require("mason-registry").get_package("delve"):get_install_path() .. "/dlv",
		args = { "dap", "-l", "127.0.0.1:${port}" },
	},
}

require("dap").configurations.go = {
	{
		type = "delve",
		name = "Debug (current file)",
		request = "launch",
		program = "${file}",
	},
	{
		type = "delve",
		name = "Debug (package)",
		request = "launch",
		program = "${fileDirname}",
	},
	{
		type = "delve",
		name = "Debug test (current file)",
		request = "launch",
		mode = "test",
		program = "${file}",
	},
	{
		-- Attach to an already-running process — useful for debugging a
		-- Go service already running under `go run` in a tmux terminal pane
		type = "delve",
		name = "Attach to running process",
		request = "attach",
		mode = "local",
		processId = require("dap.utils").pick_process,
	},
}
