-- lua/user/options.lua
--
-- Native vim.opt settings only. No plugin config lives here — that
-- discipline keeps this file stable even as the plugin list churns.

local opt = vim.opt

-- ── Display ────────────────────────────────────────────────────────
opt.number = true          -- absolute number on the current line
opt.relativenumber = true  -- relative numbers elsewhere — makes 5j / 3dk etc.
                            -- trivial to count at a glance; this pairs with
                            -- "preserve native motions" from your brief
opt.termguicolors = true   -- true color; Ghostty supports it, no reason not to
opt.signcolumn = "yes"     -- reserve gutter space permanently for git signs /
                            -- LSP diagnostics so the text doesn't shift when
                            -- they appear
opt.cursorline = true      -- subtle line highlight, easier to track cursor
                            -- across a wide monitor
opt.scrolloff = 8          -- keep 8 lines of context above/below cursor
opt.sidescrolloff = 8
opt.wrap = false           -- long lines (stack traces, long Java generics)
                            -- stay on one line; you scroll horizontally
                            -- instead of visually wrapping

-- Show whitespace explicitly. Go is tab-indented by gofmt; Java code you'll
-- write is space-indented. Being able to SEE which is which prevents the
-- classic "mixed indentation" diagnostic surprise.
opt.list = false -- visible whitespace markers off — was showing a
                  -- marker on every indented line in Go files (gofmt
                  -- indents with real tab characters), which is
                  -- clutter rather than useful signal for daily work

-- ── Indentation defaults ──────────────────────────────────────────
-- These are GLOBAL fallbacks. Go files get tab-based indentation and
-- Java files get their own settings via ftplugin/ in a later stage —
-- do not hand-tune indentation here per language, that's what
-- after/ftplugin/<lang>.lua files are for, and it keeps this file
-- language-agnostic.
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.smartindent = true

-- ── Search ─────────────────────────────────────────────────────────
opt.ignorecase = true
opt.smartcase = true       -- ignorecase, UNLESS the search has a capital
                            -- letter in it — the standard sane default
opt.incsearch = true
opt.hlsearch = true

-- ── Splits ─────────────────────────────────────────────────────────
opt.splitright = true      -- vertical splits open to the right
opt.splitbelow = true      -- horizontal splits open below
                            -- (matches how most people scan: new content
                            -- appears where you'd naturally look next)

-- ── System integration ────────────────────────────────────────────
-- Your tmux config already pipes visual-mode yanks to xclip. Setting
-- clipboard=unnamedplus means Neovim's default register IS the system
-- clipboard, so yank/paste behaves identically whether you're inside
-- tmux copy-mode or inside Neovim. One mental model, not two.
opt.clipboard = "unnamedplus"
opt.mouse = "a"             -- mostly for resizing splits by drag; motions
                            -- stay keyboard-driven

-- ── Performance / responsiveness ──────────────────────────────────
opt.updatetime = 250        -- default is 4000ms — far too slow for LSP
                            -- features like CursorHold diagnostics/hover
                            -- to feel responsive
opt.timeoutlen = 400        -- how long Neovim waits after a prefix key
                            -- (like <leader>) before giving up on a longer
                            -- mapping — tuned later alongside which-key

-- ── Persistence ────────────────────────────────────────────────────
opt.undofile = true         -- undo history survives closing the file
opt.swapfile = false        -- with undofile + no crashes-in-practice, the
                             -- swapfile mostly just creates clutter and
                             -- "found a swap file" prompts

-- ── Completion behavior (used once we wire up LSP + completion) ───
opt.completeopt = { "menu", "menuone", "noselect" }

-- ── Diagnostics floating windows / borders look better with this ──
opt.pumheight = 10          -- cap the completion popup height so it doesn't
                             -- dominate the screen on long candidate lists