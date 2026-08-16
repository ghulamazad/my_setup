-- lua/user/autocmds.lua
--
-- General-purpose autocommands that aren't tied to any specific plugin.

local augroup = vim.api.nvim_create_augroup("UserAutocmds", { clear = true })

-- ── Autosave on losing focus ────────────────────────────────────────
-- Mirrors VSCode's "save automatically when you switch away from this
-- file" behavior. Two triggers:
--   BufLeave  -> you switched to a DIFFERENT BUFFER inside Neovim
--                (e.g. jumped to another file via Telescope)
--   FocusLost -> the Neovim WINDOW itself lost OS-level focus
--                (e.g. alt-tabbed to another Ghostty pane/app)
--
-- Deliberately does NOT save on every keystroke/InsertLeave — that
-- would fight with LSP features that expect you to still be mid-edit,
-- and would spam formatters if you have format-on-save configured
-- later. "Save when you walk away" is the specific behavior asked for.
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost" }, {
  group = augroup,
  desc = "Autosave the buffer when it loses focus",
  callback = function(ev)
    local buf = ev.buf

    -- Guard conditions — only save real, editable, already-named files:
    if
      vim.bo[buf].buftype ~= "" -- skip terminals, neo-tree, Telescope
                                -- prompts, etc. (they have a non-empty
                                -- buftype; real files have "")
      or not vim.bo[buf].modifiable
      or vim.bo[buf].readonly
      or vim.api.nvim_buf_get_name(buf) == "" -- unsaved [No Name] buffer
                                               -- with nowhere to save to
      or not vim.bo[buf].modified -- nothing changed, nothing to do
    then
      return
    end

    -- IMPORTANT: don't write synchronously here. BufLeave/FocusLost
    -- fire WHILE a transition is in progress (e.g. mid-way through
    -- Telescope opening a picker). Writing immediately produces a
    -- status message that collides with that transition and eats your
    -- next keystrokes until you press Esc to clear a hit-enter prompt.
    -- vim.schedule defers this to run right after the current event
    -- finishes, once the screen has settled.
    --
    -- Also using `noautocmd`: once we add LSP format-on-save later
    -- (triggered on BufWritePre), we don't want glancing away from a
    -- half-written file to trigger a full reformat every time — that's
    -- reserved for deliberate `:w`. Autosave here is purely "don't
    -- lose my work", not "clean up my code".
    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].modified then
        vim.api.nvim_buf_call(buf, function()
          vim.cmd("silent! noautocmd write")
        end)
      end
    end)
  end,
})

-- ── Highlight on yank ────────────────────────────────────────────
-- Brief visual flash on whatever text you just yanked — small
-- confirmation that the yank grabbed what you expected, especially
-- useful with multi-line or textobject yanks where it's not always
-- obvious at a glance what got selected.
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  desc = "Highlight yanked text briefly",
  callback = function()
    vim.hl.on_yank({ higroup = "IncSearch", timeout = 150 })
  end,
})