return {
  "xeluxee/competitest.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  ft = "cpp",
  opts = {
    template_file = vim.fn.stdpath("config") .. "/cp-assets/template.cpp",
    compile_command = {
      cpp = { exec = "g++", args = { "-std=c++20", "-O2", "-Wall", "-DLOCAL", "$(FNAME)", "-o", "$(FNOEXT)" } },
    },
    run_command = {
      cpp = { exec = "./$(FNOEXT)" },
    },
    view_output_diff = true,
  },
  keys = {
    { "<leader>tc", "<cmd>CompetiTest run<cr>", desc = "CP: run test cases" },
    { "<leader>ta", "<cmd>CompetiTest add_testcase<cr>", desc = "CP: add test case manually" },
    { "<leader>te", "<cmd>CompetiTest edit_testcase<cr>", desc = "CP: edit a test case" },
    { "<leader>tx", "<cmd>CompetiTest delete_testcase<cr>", desc = "CP: delete a test case" },
  },
}