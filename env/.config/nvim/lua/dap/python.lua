require("dap-python").setup(
  require("mason-registry").get_package("debugpy"):get_install_path() .. "/venv/bin/python"
)