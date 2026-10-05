-- lua/plugins/competitest.lua
-- competitest.nvim: competitive programming test runner inside Neovim.
-- Manages sample test cases (add/edit/delete), runs them, shows pass/fail.
-- Only active for C++ and Python files (the two dominant CP languages).
--
-- Keymaps use <leader>ct prefix (Competitive Test).

return {
    {
        "xeluxee/competitest.nvim",
        dependencies = { "MunifTanjim/nui.nvim" },
        ft = { "cpp", "c", "python" },   -- only load for CP filetypes
        keys = {
            { "<leader>ctr", "<cmd>CompetiTest run<CR>",           desc = "CT: Run tests" },
            { "<leader>cta", "<cmd>CompetiTest add_testcase<CR>",  desc = "CT: Add test case" },
            { "<leader>cte", "<cmd>CompetiTest edit_testcase<CR>", desc = "CT: Edit test case" },
            { "<leader>ctd", "<cmd>CompetiTest delete_testcase<CR>", desc = "CT: Delete test case" },
            { "<leader>ctR", "<cmd>CompetiTest receive testcases<CR>", desc = "CT: Receive from CP" },
        },
        opts = {
            -- Compile command for C++ (fast O2 build for CP speed)
            compile_command = {
                cpp = {
                    exec  = "g++",
                    args  = {
                        "-std=c++17", "-O2", "-o",
                        "$(FNOEXT)",   -- output binary named after source file sans extension
                        "$(FNAME)",
                    },
                },
                c = {
                    exec = "gcc",
                    args = { "-std=c11", "-O2", "-o", "$(FNOEXT)", "$(FNAME)" },
                },
                python = { exec = "python3", args = { "$(FNAME)" } },
            },

            -- Run command (binary for compiled, interpreter for python)
            run_command = {
                cpp    = { exec = "$(FNOEXT)" },
                c      = { exec = "$(FNOEXT)" },
                python = { exec = "python3", args = { "$(FNAME)" } },
            },

            -- Timeout per test case in milliseconds
            maximum_time = 5000,

            -- Layout: show input, expected, and actual output side by side
            view_output_diff = true,

            -- Test case storage: keep *.testcases in a hidden dir beside the source
            testcases_use_single_file = false,
            testcases_directory = "./.$(FNOEXT)_tests",
        },
    },
}
