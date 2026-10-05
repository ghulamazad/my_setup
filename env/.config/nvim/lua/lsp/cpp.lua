-- lua/lsp/cpp.lua
-- clangd LSP configuration.
-- Owner: Mason (via mason-lspconfig automatic_enable → "clangd").
-- This file supplies the settings/capabilities; mason-lspconfig handles the enable().
--
-- For CP: clangd will find compile_commands.json if you generate it,
-- or fall back to a default compile flags for single-file C++17 projects.

vim.lsp.config("clangd", {
    cmd = {
        "clangd",
        "--background-index",           -- pre-index in background for instant go-to-def
        "--clang-tidy",                 -- lint with clang-tidy rules
        "--header-insertion=iwyu",      -- include-what-you-use insertions
        "--completion-style=detailed",
        "--function-arg-placeholders",  -- fill in placeholder arguments on completion
        "--fallback-style=google",      -- style when no .clang-format is present
    },
    -- Offset encoding: clangd uses utf-16 by default; tell it we support utf-8
    -- so we get correct cursor positions in Neovim (which is utf-8 native).
    capabilities = {
        offsetEncoding = { "utf-8" },
    },
    root_dir = function(fname)
        return vim.fs.root(fname, {
            ".clangd",
            ".clang-tidy",
            ".clang-format",
            "compile_commands.json",
            "compile_flags.txt",
            "CMakeLists.txt",
            "Makefile",
            -- Fallback: single-file CP usage — use the file's directory
        }) or vim.fn.fnamemodify(fname, ":h")
    end,
})
