# dotfiles — Usage Guide

> A complete reference for the tooling, keymaps, and workflows in this setup.
> Stack: **Zsh · Ghostty · tmux · Neovim 0.11+ · mise · starship**
> OS: Arch Linux (Omarchy) + Hyprland on Wayland

---

## Table of Contents

1. [First Boot Setup](#1-first-boot-setup)
2. [Shell (Zsh)](#2-shell-zsh)
3. [tmux](#3-tmux)
4. [Neovim — Basics](#4-neovim--basics)
5. [Neovim — LSP](#5-neovim--lsp)
6. [Neovim — Files & Search (Telescope + Neo-tree)](#6-neovim--files--search)
7. [Neovim — Git (Fugitive + Gitsigns)](#7-neovim--git)
8. [Neovim — Debugging (DAP)](#8-neovim--debugging)
9. [Neovim — Harpoon (File Marks)](#9-neovim--harpoon)
10. [Neovim — Theme & Appearance](#10-neovim--theme--appearance)
11. [Neovim — Go Workflow](#11-neovim--go-workflow)
12. [Neovim — Rust Workflow](#12-neovim--rust-workflow)
13. [Neovim — Python Workflow](#13-neovim--python-workflow)
14. [Neovim — Competitive Programming (C++)](#14-neovim--competitive-programming)
15. [Mise (Runtime Manager)](#15-mise-runtime-manager)
16. [Starship Prompt](#16-starship-prompt)
17. [mpv](#17-mpv)
18. [Maintenance](#18-maintenance)

---

## 1. First Boot Setup

### Full install (new machine)

```bash
# Clone the repo
git clone git@github.com:<you>/my_setup.git ~/dotfiles
cd ~/dotfiles

# One command: packages → configs → mise toolchains
./bootstrap.sh

# Dry-run first (recommended)
./bootstrap.sh --dry-run
```

### Selective install

```bash
# Install only packages (idempotent — skips already installed)
make packages

# Deploy only configs into $HOME
make config

# Deploy a single package only
./install-config.sh --only nvim

# Symlink instead of copy (edits in $HOME reflect immediately in repo)
./install-config.sh --symlink

# Preview without changing anything
make dry-run
```

### After install

```bash
# Health-check every tool on PATH + config validity
make doctor

# First Neovim open: lazy.nvim auto-installs all plugins
nvim

# Inside Neovim: check plugin status
:Lazy
# Upgrade all plugins
:Lazy sync
# Install Mason tools (DAP adapters, vtsls)
:Mason
```

> **Identity file**: `~/.config/git/local` is auto-created but intentionally empty.
> Fill in your name, email, and optional signing key — it is never committed.

```ini
# ~/.config/git/local
[user]
    name  = Your Name
    email = you@example.com
```

---

## 2. Shell (Zsh)

### Key files

| File | Purpose |
|---|---|
| `~/.zshrc` | Entry point — sources all below |
| `~/.zsh/aliases.zsh` | All shell aliases |
| `~/.zsh/functions.zsh` | Shell functions |
| `~/.zsh/fzf.zsh` | fzf key-bindings and preview config |

### Essential aliases

| Alias | Command | Notes |
|---|---|---|
| `ls` / `ll` / `la` | `eza` variants | With icons and git status |
| `cat` | `bat` | Syntax-highlighted cat |
| `find` | `fd` | Faster, friendlier |
| `grep` | `rg` | ripgrep |
| `cd` | `z` (zoxide) | Frecency-based cd |
| `lg` | `lazygit` | TUI git client |
| `glow <file>` | Render markdown | In terminal |

### fzf key-bindings

| Binding | Action |
|---|---|
| `Ctrl-r` | Fuzzy search shell history |
| `Ctrl-t` | Fuzzy file picker (insert path) |
| `Alt-c` | Fuzzy `cd` into a directory |

---

## 3. tmux

**Prefix:** `Ctrl-a`

### Sessions & windows

| Binding | Action |
|---|---|
| `prefix c` | New window |
| `prefix ,` | Rename window |
| `prefix n` / `p` | Next / previous window |
| `prefix 1-9` | Jump to window by number |
| `prefix d` | Detach session |
| `prefix $` | Rename session |
| `prefix s` | Session switcher |

### Splits / panes

| Binding | Action |
|---|---|
| `prefix \|` | Split vertically (new column) |
| `prefix -` | Split horizontally (new row) |
| `prefix h/j/k/l` | Move between panes |
| `prefix H/J/K/L` | Resize pane |
| `prefix z` | Zoom pane (fullscreen toggle) |
| `prefix x` | Kill pane |

### Utilities

| Binding | Action |
|---|---|
| `prefix r` | Reload tmux config |
| `prefix [` | Enter copy mode (vi keys) |
| `prefix ]` | Paste buffer |

### tmux-sessionizer (Fuzzy Project Manager)

`tmux-sessionizer` provides instant fuzzy project switching with rich git/file previews, automatic session creation, collision avoidance, and hydration hooks.

#### Keybindings
- **In Zsh**: Press `Ctrl-f` anywhere to open the fuzzy session switcher.
- **In tmux**: Press `Prefix + f` (`Ctrl-a` then `f`) to open a window switcher.
- **Inside fzf**:
  - `Enter`: Open / switch to project session
  - `Ctrl-k`: Kill highlighted active session
  - `Ctrl-r`: Refresh sessions / project list
  - `Esc`: Cancel without switching

#### The 3 Architecture Files
1. **Config file** (`~/.config/tmux-sessionizer/config`):
   - Configures root paths (`~/Projects`, `~/Alien`), search paths (`~/Alien/coding-lab`, etc.), scan depth, prune filters (`node_modules`, `target`, `.git`), and hook names.
2. **Session Hydration Hook** (`~/.tmux-sessionizer`):
   - Automatically executed whenever a new project session is created.
   - Creates a background `scratch` window in the project folder and launches `nvim .` in the primary window.
   - Skips launching Neovim if opening root navigation folders (`~/Alien`, `~/Projects`).
   - Supports per-project override hooks (`<project>/.tmux-sessionizer`).
3. **Main Executable Script** (`~/.local/scripts/tmux-sessionizer`):
   - Located on your `PATH` via `~/.local/scripts`.
   - Handles fzf UI, session conflict avoidance (e.g. distinguishing `coding-lab_cpp` from other `cpp` directories), and client switching.

#### CLI Usage
```bash
# Fuzzy-pick project or active session
tmux-sessionizer

# Jump directly to a project path
tmux-sessionizer ~/Alien/coding-lab/golang
tmux-sessionizer ~/Projects/url-shortener

# List active tmux sessions
tmux-sessionizer --list

# Fuzzy-pick a session to kill
tmux-sessionizer --kill
```

---

## 4. Neovim — Basics

**Leader key:** `Space`

### Movement

| Key | Action |
|---|---|
| `Ctrl-d` / `Ctrl-u` | Half-page down/up (cursor stays centred) |
| `n` / `N` | Next/prev search result (auto-centred) |
| `J` / `K` (visual) | Move selected lines down/up |
| `[f` / `]f` | Jump to prev/next function (treesitter) |
| `[c` / `]c` | Jump to prev/next class (treesitter) |

### Windows & buffers

| Key | Action |
|---|---|
| `Ctrl-h/j/k/l` | Navigate windows |
| `Ctrl-↑/↓/←/→` | Resize window |
| `Shift-h` / `Shift-l` | Prev / next buffer |
| `<leader>bd` | Delete (close) buffer |

### Editing

| Key | Action |
|---|---|
| `<leader>y` | Yank to system clipboard |
| `<leader>p` (visual) | Paste without overwriting yank register |
| `<Esc>` | Clear search highlight |
| `<leader>q` | Open quickfix list |
| `]q` / `[q` | Next / prev quickfix entry |
| `<leader>tt` | Open terminal at project root |

### Treesitter text objects

| Key | Selection |
|---|---|
| `af` / `if` | Around / inside function |
| `ac` / `ic` | Around / inside class/struct |
| `ab` / `ib` | Around / inside block |
| `aa` / `ia` | Around / inside argument |

---

## 5. Neovim — LSP

Powered by native `vim.lsp` (Neovim 0.11+). No lspconfig wrapper.

### Navigation

| Key | Action |
|---|---|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | Find all references |
| `gI` | Go to implementation |
| `K` | Hover documentation |

### Actions

| Key | Action |
|---|---|
| `<leader>ca` | Code action (fix, generate, refactor) |
| `<leader>rn` | Rename symbol across project |
| `<leader>ci` | Implement missing interface methods |
| `<leader>f` | Format buffer (LSP) |
| `<leader>F` | Format buffer (conform — preferred) |
| `<leader>ih` | Toggle inlay hints (Go, Rust) |

### Diagnostics

| Key | Action |
|---|---|
| `]d` / `[d` | Next / prev diagnostic (with float) |
| `<leader>ld` | Show diagnostics for current line |

### LSP ownership

| Language | Server | Owner |
|---|---|---|
| Go | gopls | pacman |
| Rust | rust-analyzer | pacman |
| Python | pyright + ruff | pacman |
| TypeScript/JS | vtsls | Mason |
| Lua | lua-language-server | pacman |
| C/C++ | clangd | Mason |

---

## 6. Neovim — Files & Search

### Telescope — `<leader>s` prefix

| Key | Action |
|---|---|
| `<leader>sf` | Find files (`fd`, respects `.gitignore`) |
| `<leader>sr` | Recent files |
| `<leader>sb` | Open buffers |
| `<leader>sg` | Live grep (ripgrep) |
| `<leader>sw` | Grep word under cursor |
| `<leader>ss` | Document symbols (LSP) |
| `<leader>sS` | Workspace symbols (LSP) |
| `<leader>sd` | Buffer diagnostics |
| `<leader>sD` | All diagnostics |
| `<leader>sgf` | Git files |
| `<leader>sgl` | Git commits |
| `<leader>sgb` | Git branches |
| `<leader>sh` | Help tags |
| `<leader>sk` | Keymaps |
| `<leader>s.` | Resume last search |

**Inside Telescope picker:**

| Key | Action |
|---|---|
| `Ctrl-j/k` | Move up/down |
| `Ctrl-q` | Send all results to quickfix |
| `Esc` | Close picker |

### Neo-tree — File Explorer

| Key | Action |
|---|---|
| `<leader>e` | Toggle file explorer |
| `<leader>E` | Reveal current file in tree |
| `<leader>ge` | Git status view in tree |

**Inside Neo-tree:**

| Key | Action |
|---|---|
| `Enter` | Open file |
| `Ctrl-s` | Open in horizontal split |
| `Ctrl-v` | Open in vertical split |
| `a` | New file/folder |
| `d` | Delete |
| `r` | Rename |
| `Y` | Copy absolute path to clipboard |
| `H` | Toggle hidden files |

---

## 7. Neovim — Git

Two complementary tools: **gitsigns** (hunk-level) + **fugitive** (repo-level).

### Gitsigns — hunk operations

| Key | Action |
|---|---|
| `]h` / `[h` | Next / prev hunk |
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>hS` | Stage entire buffer |
| `<leader>hR` | Reset entire buffer |
| `<leader>hu` | Undo last staged hunk |
| `<leader>hs` (visual) | Stage selected lines only |
| `<leader>hp` | Preview hunk diff |
| `<leader>hd` | Diff file against index |
| `<leader>hD` | Diff file against HEAD~1 |
| `<leader>gb` | Toggle inline blame |
| `<leader>gB` | Full file blame list |
| `ih` (operator) | Text-object: select hunk |

### Fugitive — repo operations

| Key | Action |
|---|---|
| `<leader>gs` | Git status window |
| `<leader>gd` | Vertical diff split |
| `<leader>gc` | Commit |
| `<leader>ga` | Amend last commit |
| `<leader>gw` | Stage current file (`Gwrite`) |
| `<leader>gp` | Push |
| `<leader>gl` | Pull --rebase |
| `<leader>gL` | Compact log with graph |

**Inside Fugitive status window (`<leader>gs`):**

| Key | Action |
|---|---|
| `s` | Stage file/hunk |
| `u` | Unstage file |
| `=` | Toggle inline diff |
| `cc` | Commit staged |
| `ca` | Amend |
| `dd` | Diff split |
| `q` | Close |

### Lazygit (TUI)

```bash
lg          # shell alias → opens lazygit
```

Full keyboard-driven staging, commit, rebase, cherry-pick, and log browsing.

---

## 8. Neovim — Debugging (DAP)

**`<leader>d` prefix.**

### Control

| Key | Action |
|---|---|
| `<leader>dc` | Continue / Start session |
| `<leader>dq` | Terminate |
| `<leader>dr` | Restart |

### Step

| Key | Action |
|---|---|
| `<leader>do` | Step over |
| `<leader>di` | Step into |
| `<leader>dO` | Step out |

### Breakpoints

| Key | Action |
|---|---|
| `<leader>db` | Toggle breakpoint |
| `<leader>dB` | Conditional breakpoint |
| `<leader>dl` | Log point (print without stopping) |

### UI & eval

| Key | Action |
|---|---|
| `<leader>du` | Toggle DAP UI (sidebar + console) |
| `<leader>de` | Evaluate expression under cursor |
| `<leader>dR` | Open REPL |

### Language adapters

| Language | Adapter | Owner |
|---|---|---|
| Go | `dlv` (Delve) | pacman (runs from PATH) |
| Python | `debugpy` | Mason |
| Rust / C++ | `codelldb` | Mason |

---

## 9. Neovim — Harpoon (File Marks)

Pin up to 4 files per project for instant access — no searching.

| Key | Action |
|---|---|
| `<leader>ha` | Add current file to list |
| `<leader>hh` | Open harpoon menu |
| `Ctrl-1` | Jump to slot 1 |
| `Ctrl-2` | Jump to slot 2 |
| `Ctrl-3` | Jump to slot 3 |
| `Ctrl-4` | Jump to slot 4 |
| `<leader>h[` | Cycle to previous in list |
| `<leader>h]` | Cycle to next in list |

> **Workflow**: Open your main file → `<leader>ha`, open handler → `<leader>ha`, open tests → `<leader>ha`. Then `Ctrl-1/2/3` to switch instantly without any fuzzy-search overhead.

---

## 10. Neovim — Theme & Appearance

Three themes, toggle without restarting:

| Key | Theme | Best for |
|---|---|---|
| `<leader>t1` | **kanagawa-dragon** | Long sessions (default) — dark, muted ink-wash palette |
| `<leader>t2` | kanagawa-wave | Morning / demos — richer, more vivid colours |
| `<leader>t3` | rose-pine-moon | Evening / night shift — warm rose/purple tones |

**Why kanagawa-dragon by default?**  
It's the lowest-saturation variant: backgrounds sit at `#181616`, almost no pure whites appear. After 4+ hours, eye strain is noticeably lower than higher-contrast themes.

**Additional eye-care settings already applied:**
- `dimInactive = true` — non-focused splits are dimmed, reducing focal competition
- Softened cursor line number (amber, not bright white)
- Gentle amber search highlight instead of harsh yellow

---

## 11. Neovim — Go Workflow

| Key | Action |
|---|---|
| `<leader>gt` | `go test ./...` |
| `<leader>gT` | Test function under cursor |
| `<leader>gb` | `go build ./...` |
| `<leader>gv` | `go vet ./...` |
| `<leader>gm` | `go mod tidy` |

Format on save via `gofumpt` (stricter than `gofmt`). Inlay hints available — toggle with `<leader>ih`.

```bash
# Shell: run benchmarks
go test -bench=. -benchmem ./...

# Profile (CPU)
go test -cpuprofile cpu.prof ./...
go tool pprof cpu.prof
```

---

## 12. Neovim — Rust Workflow

Format on save via `rustfmt`. Inlay hints available — toggle with `<leader>ih`.

```bash
# Shell
cargo build
cargo test
cargo clippy -- -D warnings    # deny all warnings
cargo doc --open
```

**rust-analyzer features available via LSP:**
- `<leader>ca` → expand macro, fill struct fields, add missing arms
- `gd` → go to definition across crates
- `K` → inline documentation with examples

---

## 13. Neovim — Python Workflow

Two servers run simultaneously:
- **pyright** — type checking, go-to-definition, completions
- **ruff** — fast lint + format (replaces flake8, isort, black for new projects)

Format on save via `ruff_format`. For projects that use `black`, `:ConformDisable` then `<leader>f` uses pyright's LSP formatter.

```bash
# Shell: virtual environment (mise-managed Python)
mise use python@3.12
python -m venv .venv
source .venv/bin/activate

# Type check outside Neovim
pyright .

# Lint + fix
ruff check . --fix
```

---

## 14. Neovim — Competitive Programming

### Compile & run (C++)

| Key | Action |
|---|---|
| `<leader>cr` | Compile (C++17 O2) + run in terminal split |
| `<leader>cc` | Compile only (check errors) |
| `<leader>ci` | Open `input.txt` beside source |

### competitest.nvim — test cases

| Key | Action |
|---|---|
| `<leader>cta` | Add test case (input + expected output) |
| `<leader>cte` | Edit test case |
| `<leader>ctd` | Delete test case |
| `<leader>ctr` | Run all test cases |
| `<leader>ctR` | Receive test cases from Competitive Companion browser extension |

Test cases are stored in a hidden directory `./<filename>_tests/` beside the source file — they don't pollute the directory.

---

## 15. Mise (Runtime Manager)

Mise manages per-project runtime versions via `.mise.toml` or `.tool-versions`.

```bash
# See all available versions
mise ls-remote go
mise ls-remote node
mise ls-remote python

# Use a specific version (writes .mise.toml in cwd)
mise use go@1.23
mise use node@22
mise use python@3.12

# Install all versions pinned in config
mise install

# See what's active in current directory
mise current

# Run a command in a specific runtime
mise exec go@1.22 -- go build .

# Global fallback versions (when no project config)
mise use --global go@latest
```

Config file: `~/.config/mise/config.toml`

---

## 16. Starship Prompt

Prompt auto-detects project context and shows only relevant info:

```
~/projects/myapi  main ⇡2 !1  1.23  2.1s
❯
```

| Segment | Meaning |
|---|---|
| `~/projects/myapi` | Truncated path, anchored to repo root |
| ` main` | Git branch |
| `⇡2 !1` | 2 commits ahead, 1 modified file |
| ` 1.23` | Go version (inside `go.mod` project) |
| `2.1s` | Last command took 2.1 seconds |
| `❯` green | Last command succeeded |
| `❯` red | Last command failed |
| `❮` purple | Vi normal mode |

Modules shown only inside relevant projects: Go, Rust, Python, Node.js, Lua.

---

## 17. mpv

### Default keybindings (customised)

| Key | Action |
|---|---|
| `Space` | Pause / play |
| `[` / `]` | Speed ×0.9 / ×1.1 |
| `\` | Reset speed to 1× |
| `,` / `.` | Step one frame back/forward |
| `m` | Mute |
| `9` / `0` | Volume down / up |
| `s` | Screenshot (no subtitles) |
| `S` | Screenshot (with subtitles) |
| `j` / `J` | Cycle subtitle tracks |
| `z` / `Z` | Subtitle delay ±100ms |
| `a` / `A` | Cycle audio tracks |
| `!` / `@` | Previous / next chapter |
| `<` / `>` | Previous / next playlist file |
| `i` | Toggle stats overlay |
| `f` | Fullscreen toggle |
| `q` | Quit (saves position) |
| `Ctrl-v` | Open file path from Wayland clipboard |

Sessions are resumed automatically (`save-position-on-quit`).

---

## 18. Maintenance

### Update everything

```bash
# System packages
sudo pacman -Syu

# AUR packages
yay -Syu

# Neovim plugins
nvim -c ':Lazy sync' -c 'qa'

# mise toolchains
mise upgrade

# Treesitter parsers (inside nvim)
# :TSUpdate
```

### Health check

```bash
make doctor
```

Checks every tool on PATH, validates zsh syntax, runs `nvim --headless +qa`, and prints startup time.

### Backup & restore configs

Every time `install-config.sh` replaces an existing file, the original is saved to:

```
~/.dotfiles-backup/<YYYY-MM-DD-HHMMSS>/
```

To restore:

```bash
cp -a ~/.dotfiles-backup/<timestamp>/. ~/
```

### Format-on-save control

```vim
" Disable for current buffer (e.g. file with intentional formatting)
:ConformDisable

" Disable globally for this session
:ConformDisable!

" Re-enable
:ConformEnable
```

### Adding a new tool to the setup

1. Add the package name + comment to `packages.txt` (official) or `aur.txt` (AUR)
2. Run `make packages` — it only installs what's missing
3. If it needs a config, create `<toolname>/.config/<toolname>/...` and run `make config`

---

> **Tip:** Run `make doctor` after any major update to verify nothing is broken.
