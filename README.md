# my_setup — dotfiles

Personal dotfiles for a backend/infrastructure engineer.
**Stack:** Zsh · Ghostty · tmux · Neovim 0.11+ · Starship · Arch Linux (Omarchy)

## Quick Start

```bash
./bootstrap.sh            # full install: packages → deploy configs
./bootstrap.sh --dry-run  # preview first
make test                 # run sandboxed test suite
make doctor               # health-check tools and configs
```

## Documentation

- **[USAGE.md](USAGE.md)** — complete user manual: keymaps, workflows, tmux-sessionizer, and tool guides.
- **[CHANGES.md](CHANGES.md)** — architecture decisions, migration records, and review notes.

## Layout (`env/` Home Mirror)

All dotfiles live inside `env/` which directly mirrors `$HOME`:

```text
env/
├── .zshrc
├── .zsh/
│   ├── aliases.zsh
│   ├── functions.zsh
│   └── fzf.zsh
├── .config/
│   ├── nvim/                   # Neovim 0.11+ (Tokyo Night, LSP, DAP, Treesitter)
│   ├── tmux/                   # tmux (prefix C-a, Tokyo Night theme)
│   ├── tmux-sessionizer/       # tmux-sessionizer config (search paths & excludes)
│   ├── starship/               # Starship prompt
│   ├── git/                    # Git config & ignore
│   ├── mpv/                    # mpv config & keybindings
│   └── feh/                    # feh wallpaper & image config
├── .tmux-sessionizer           # Session hydration hook (spawns nvim & scratch window)
└── .local/
    └── scripts/
        └── tmux-sessionizer    # Fuzzy project sessionizer script
```

### tmux-sessionizer Architecture
1. **Config** (`~/.config/tmux-sessionizer/config`): Defines search paths (`Projects`, `Alien`, `Alien/coding-lab`), depth, and prune rules.
2. **Session Hook** (`~/.tmux-sessionizer`): Automatically invoked upon session creation to launch `nvim .` and a background `scratch` window.
3. **Executable** (`~/.local/scripts/tmux-sessionizer`): Fuzzy project picker with git preview, collision-free naming, and CLI controls.
