-- lua/plugins/tmux-navigator.lua
--
-- Makes <C-h/j/k/l> move between Neovim splits AND tmux panes
-- seamlessly — one set of keys for both, no need to think about which
-- "layer" (tmux vs Neovim) you're currently inside. This is the
-- payoff of confirming <C-h/j/k/l> was free of any i3/terminal
-- collision earlier.
--
-- Requires a matching change in ~/.config/tmux/tmux.conf (see the
-- accompanying instructions) so tmux passes these keys through to
-- Neovim when Neovim is the focused pane, and only handles them
-- itself (switch pane) otherwise.

return {
  "christoomey/vim-tmux-navigator",
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
  },
  keys = {
    -- The plugin maps these by default anyway, but declaring them
    -- explicitly here keeps every keybinding in this config visible
    -- and greppable in one place, rather than relying on a plugin's
    -- implicit defaults.
    { "<C-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Navigate: window/pane left" },
    { "<C-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Navigate: window/pane down" },
    { "<C-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Navigate: window/pane up" },
    { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Navigate: window/pane right" },
  },
}