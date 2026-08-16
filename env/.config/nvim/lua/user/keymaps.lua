-- lua/user/keymaps.lua
--
-- Hand-written keymaps that aren't specific to any one plugin (those
-- live inside their own lua/plugins/<name>.lua file instead, next to
-- the plugin they belong to — see telescope.lua for that pattern).

local keymap = vim.keymap.set

-- Ctrl+c already exits insert mode by default, but it skips firing
-- InsertLeave properly and doesn't complete pending abbreviation
-- expansion the way Esc does. Force it to be a true alias of Esc so
-- there's no behavioral difference between the two — one less thing
-- to think about, and it protects any InsertLeave-triggered behavior
-- we add later (formatting, etc.) from silently not firing.
keymap("i", "<C-c>", "<Esc>", { desc = "Exit insert mode (alias of Esc)" })

-- Delete WITHOUT overwriting your last yank. Normal `d` always
-- overwrites the unnamed register, which breaks the common
-- "yank this, delete that, paste the yank" flow. <leader>D routes the
-- deleted text to the black-hole register instead, leaving your last
-- yank untouched. (Capital D, not lowercase — lowercase <leader>d is
-- our entire debug prefix; a bare mapping there would force Neovim to
-- wait out timeoutlen on every debug keystroke to disambiguate.)
keymap({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without overwriting yank" })

-- Interactive search-and-replace for the word under the cursor.
-- Drops you into a pre-filled :%s command with the word already typed
-- and the cursor positioned to type the replacement — faster than
-- typing the whole substitute command by hand for the common case.
keymap(
  "n",
  "<leader>sR",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Search: replace word under cursor (interactive)" }
)

-- Quickfix / location-list navigation, centering the screen on each
-- jump (zz). Bracket-prefixed to match the existing ]d/[d (diagnostics)
-- and ]c/[c (git hunks) convention already in this config — NOT
-- <C-j>/<C-k>, which would collide with tmux-navigator's pane movement.
keymap("n", "]q", "<cmd>cnext<cr>zz", { desc = "Next quickfix item" })
keymap("n", "[q", "<cmd>cprev<cr>zz", { desc = "Previous quickfix item" })
keymap("n", "]l", "<cmd>lnext<cr>zz", { desc = "Next location-list item" })
keymap("n", "[l", "<cmd>lprev<cr>zz", { desc = "Previous location-list item" })

-- Q enters Ex mode by default — almost never intentional, easy to
-- fat-finger from a capitalized `q` (record macro). Disabled outright.
keymap("n", "Q", "<nop>", { desc = "Disabled (accidental Ex-mode trigger)" })

-- Opens a new tmux window running your tmux-sessionizer script,
-- directly from Neovim — no need to detach/prefix first. Overrides
-- native Ctrl+f (scroll forward a page); that's a low-cost trade
-- given how much more often project-switching gets reached for.
keymap(
  "n",
  "<C-f>",
  "<cmd>silent !tmux neww tmux-sessionizer<CR>",
  { desc = "Open tmux-sessionizer" }
)

-- ── <leader>b — buffer ─────────────────────────────────────────────
-- Self-contained (no plugin dependency) — previously lived alongside
-- bufferline's visual tab bar, which was removed since it doesn't fit
-- a one-buffer-at-a-time workflow. These keymaps didn't actually need
-- it, except <leader>bb (dropped — <leader>fb already does the same
-- job via Telescope) and <leader>bo (reimplemented natively below).
keymap("n", "<leader>bn", "<cmd>bnext<cr>", { desc = "Buffer: next" })
keymap("n", "<leader>bp", "<cmd>bprevious<cr>", { desc = "Buffer: previous" })

keymap("n", "<leader>bo", function()
  local current = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= current and vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted then
      vim.cmd("bdelete " .. buf)
    end
  end
end, { desc = "Buffer: close all other buffers" })

keymap("n", "<leader>bd", function()
  -- Close the current buffer WITHOUT closing the split/window it's
  -- in — the default :bdelete closes the window too if it's the last
  -- buffer shown there, which is rarely what you want when you're
  -- just done with one file.
  local current = vim.api.nvim_get_current_buf()
  vim.cmd("bnext")
  if vim.api.nvim_get_current_buf() ~= current then
    vim.cmd("bdelete " .. current)
  else
    vim.cmd("bdelete")
  end
end, { desc = "Buffer: close (keep window open)" })

keymap("n", "<leader>bD", "<cmd>bdelete!<cr>", { desc = "Buffer: force close, discard changes" })