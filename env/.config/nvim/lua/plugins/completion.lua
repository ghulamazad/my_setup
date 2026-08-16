-- lua/plugins/completion.lua
--
-- blink.cmp: the current fastest/most-adopted completion engine in the
-- ecosystem (fuzzy matching implemented in Rust, prebuilt binary
-- downloaded automatically — no local Rust toolchain needed despite
-- that). Superseded nvim-cmp as the default choice in most new setups.
--
-- Deliberately loaded EAGERLY (no `event`/`cmd` lazy-trigger) — its
-- get_lsp_capabilities() must be registered with vim.lsp.config('*', ...)
-- in lsp/init.lua BEFORE gopls (or jdtls later) starts, or the server
-- won't know to send back rich/snippet-aware completions. Lazy-loading
-- this on InsertEnter, as many tutorials show, risks that ordering.

return {
  "saghen/blink.cmp",
  version = "1.*", -- use tagged releases (ships prebuilt binaries);
                    -- avoids needing a local Rust toolchain to build
                    -- from source
  opts = {
    keymap = {
      -- 'default' preset: <C-space> trigger, <C-e> dismiss, <C-y>
      -- accept, <Tab>/<S-Tab> jump forward/back through snippet
      -- placeholders (falls through to normal Tab when not in a
      -- snippet), <C-n>/<C-p> or arrow keys to move the selection.
      -- Nothing here shadows a native Vim motion — it's entirely
      -- insert-mode-only completion UI.
      preset = "default",
    },

    appearance = {
      nerd_font_variant = "mono", -- matches JetBrainsMono Nerd Font
    },

    completion = {
      documentation = { auto_show = true }, -- shows doc popup for the
                                             -- highlighted suggestion
                                             -- without extra keypress
      menu = { border = "rounded" },
    },

    -- Where suggestions come from, and in what priority:
    --   lsp    -> gopls (and jdtls later) — real symbol-aware completion
    --   path   -> filesystem paths, e.g. importing a local file
    --   buffer -> words already present in open buffers, as a fallback
    sources = {
      default = { "lsp", "path", "buffer" },
    },

    signature = { enabled = true }, -- function signature popup while
                                     -- typing arguments, in addition
                                     -- to the <leader>ls keymap we
                                     -- already added
  },
  opts_extend = { "sources.default" },
}