-- lua/dap/python.lua
-- debugpy: owned by Mason (no pacman package for the nvim-dap integration).
-- dap-python reads the Python path from the Mason-installed debugpy venv.

require("dap-python").setup(
    require("mason-registry").get_package("debugpy"):get_install_path()
        .. "/venv/bin/python"
)
