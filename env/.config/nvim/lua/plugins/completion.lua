return {
  "saghen/blink.cmp",
  event = "InsertEnter", -- lazy-load: no cost until you actually start typing
  version = "1.*",       -- pin to major version — blink's config schema
                          -- occasionally has breaking changes between majors
  dependencies = {
    -- Snippet engine blink uses under the hood for LSP snippet
    -- expansion (function args, boilerplate from jdtls code actions, etc.)
    "rafamadriz/friendly-snippets",
  },

  opts = {
    keymap = {
      -- "default" preset = mostly-standard, Tab-based, minimal surprise.
      -- We override the two entries below that matter most for
      -- preserving Vim-native feel.
      preset = "default",

      -- Enter only confirms an EXPLICITLY selected item, never the
      -- first item by default — this is the single most important
      -- setting for people who don't want completion to "hijack"
      -- normal typing/newlines.
      ["<CR>"] = { "accept", "fallback" },

      -- Tab/S-Tab cycle the menu; falls through to normal Tab
      -- behavior (indent) when the menu isn't open.
      ["<Tab>"] = { "select_next", "fallback" },
      ["<S-Tab>"] = { "select_prev", "fallback" },

      -- Ctrl-Space manually triggers completion (standard across
      -- basically every editor — keeps muscle memory portable)
      ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },

      -- Escape always closes the menu without touching insert mode —
      -- native Vim Esc behavior stays completely untouched otherwise
      ["<Esc>"] = { "hide", "fallback" },
    },

    appearance = {
      nerd_font_variant = "mono", -- matches JetBrainsMono Nerd Font you already use
    },

    -- Sources: where completion candidates come from, in priority order
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },

    completion = {
      -- Documentation popup (shows Javadoc/godoc/docstring for the
      -- highlighted item) — auto-opens after a short delay, not instantly,
      -- so it doesn't flash on every cursor move through the menu
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
      },
      -- Ghost text: shows the top completion inline (dimmed) as you
      -- type, like an inline preview — off here, because combined
      -- with LSP inlay hints (Stage 3) it gets visually busy fast.
      -- Turn on later if you want it: ghost_text = { enabled = true }
      menu = {
        border = "rounded",
      },
    },

    signature = {
      -- Function signature help popup while typing arguments —
      -- critical for Java/Spring (long constructor/method signatures)
      -- and Go (multiple return values)
      enabled = true,
      window = { border = "rounded" },
    },
  },
  opts_extend = { "sources.default" },
}