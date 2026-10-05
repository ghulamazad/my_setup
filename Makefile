# Makefile – dotfiles management targets
# Requires: bash, zsh, nvim, git, mise (for 'tools' target)

SHELL := bash
DOTFILES_DIR := $(shell pwd)
SANDBOX_HOME := /tmp/dotfiles-sandbox

.PHONY: all packages config tools test dry-run doctor help

all: help

# ── Install targets ───────────────────────────────────────────────────────────

## packages: Install all system packages (official + AUR)
packages:
	@bash "$(DOTFILES_DIR)/install-packages.sh"

## config: Deploy dotfile configs to $HOME
config:
	@bash "$(DOTFILES_DIR)/install-config.sh"

## tools: Install mise-managed toolchains (Go, Node, Python, …)
tools:
	@mise install

# ── Dry-run ───────────────────────────────────────────────────────────────────

## dry-run: Preview all changes without touching anything
dry-run:
	@echo "==> Dry run: packages"
	@bash "$(DOTFILES_DIR)/install-packages.sh" --dry-run
	@echo ""
	@echo "==> Dry run: config"
	@bash "$(DOTFILES_DIR)/install-config.sh" --dry-run

# ── Test suite ────────────────────────────────────────────────────────────────

## test: Run full sandbox test suite (safe – uses /tmp, never touches $HOME)
test:
	@echo ""
	@echo "\033[1;36m===  dotfiles sandbox test suite  ===\033[0m"
	@echo ""

	@# 1. Prepare sandbox
	@echo "\033[1;36m==> [1/6] Clean sandbox at $(SANDBOX_HOME)\033[0m"
	@rm -rf "$(SANDBOX_HOME)"
	@mkdir -p "$(SANDBOX_HOME)"

	@# 2. Syntax-check all shell scripts
	@echo ""
	@echo "\033[1;36m==> [2/6] Shell syntax check (zsh -n / bash -n)\033[0m"
	@zsh  -n "$(DOTFILES_DIR)/env/.zshrc"                        && echo " OK  env/.zshrc"
	@zsh  -n "$(DOTFILES_DIR)/env/.zsh/aliases.zsh"              && echo " OK  aliases.zsh"
	@zsh  -n "$(DOTFILES_DIR)/env/.zsh/functions.zsh"            && echo " OK  functions.zsh"
	@zsh  -n "$(DOTFILES_DIR)/env/.zsh/fzf.zsh"                  && echo " OK  fzf.zsh"
	@bash -n "$(DOTFILES_DIR)/install-packages.sh"                && echo " OK  install-packages.sh"
	@bash -n "$(DOTFILES_DIR)/install-config.sh"                  && echo " OK  install-config.sh"
	@bash -n "$(DOTFILES_DIR)/bootstrap.sh"                       && echo " OK  bootstrap.sh"
	@bash -n "$(DOTFILES_DIR)/env/.local/scripts/tmux-sessionizer"  && echo " OK  tmux-sessionizer"
	@bash -n "$(DOTFILES_DIR)/env/.tmux-sessionizer"               && echo " OK  .tmux-sessionizer"

	@# 3. Fresh install into sandbox
	@echo ""
	@echo "\033[1;36m==> [3/6] Fresh install into sandbox HOME\033[0m"
	@HOME="$(SANDBOX_HOME)" bash "$(DOTFILES_DIR)/install-config.sh" 2>&1

	@# 4. Idempotent run (second run – all files already identical, must skip)
	@echo ""
	@echo "\033[1;36m==> [4/6] Idempotent run – must report all already up to date\033[0m"
	@HOME="$(SANDBOX_HOME)" bash "$(DOTFILES_DIR)/install-config.sh" 2>&1

	@# 5. zsh startup timing (three samples)
	@echo ""
	@echo "\033[1;36m==> [5/6] zsh interactive startup time (3 samples)\033[0m"
	@for i in 1 2 3; do \
		HOME="$(SANDBOX_HOME)" zsh -c "TIMEFMT='%*E'; time zsh -i -c exit" 2>&1 | tail -1; \
	done

	@# 6. nvim headless smoke test
	@echo ""
	@echo "\033[1;36m==> [6/6] nvim --headless +qa (sandbox)\033[0m"
	@HOME="$(SANDBOX_HOME)" nvim --headless +qa 2>&1 && echo " OK  nvim headless" || echo " WARN  nvim returned errors (run :Lazy sync on first boot)"

	@echo ""
	@echo "\033[1;32m===  Test suite complete  ===\033[0m"


# ── Doctor ────────────────────────────────────────────────────────────────────

## doctor: Check every tool is on PATH and every config loads correctly
doctor:
	@echo ""
	@echo "\033[1;36m===  dotfiles doctor  ===\033[0m"
	@echo ""
	@echo "── Tool presence ──────────────────────────────────────────────"
	@for tool in \
	    zsh tmux nvim git fzf fd bat eza zoxide starship mise \
	    ripgrep lazygit delta glow \
	    gopls gofumpt dlv golangci-lint go \
	    rust-analyzer cargo \
	    pyright ruff python3 \
	    node npm prettier \
	    lua-language-server stylua \
	    gcc g++ clang \
	    mpv \
	    jq yq xh rsync entr \
	    docker; do \
		if command -v $$tool &>/dev/null; then \
			printf " \033[1;32mOK\033[0m  %-28s %s\n" "$$tool" "$$(command -v $$tool)"; \
		else \
			printf " \033[1;33mMIS\033[0m %-28s not found (install if needed)\n" "$$tool"; \
		fi; \
	done
	@echo ""
	@echo "── Config loads ────────────────────────────────────────────────"
	@zsh -n "$$HOME/.zshrc" 2>&1 && echo " OK  zsh ~/.zshrc" || echo " WARN  zsh ~/.zshrc"
	@git config --list --show-origin &>/dev/null && echo " OK  git config" || echo " WARN  git config"
	@nvim --headless +qa 2>&1 && echo " OK  nvim headless" || echo " WARN  nvim (may need :Lazy sync)"
	@tmux -V && echo " OK  tmux"
	@starship --version &>/dev/null && echo " OK  starship"
	@mise --version &>/dev/null && echo " OK  mise"
	@echo ""
	@echo "── Shell startup time ──────────────────────────────────────────"
	@zsh -c "TIMEFMT='%*E'; time zsh -i -c exit" 2>&1 | tail -1
	@echo ""
	@echo "\033[1;36m===  doctor done  ===\033[0m"

# ── Help ──────────────────────────────────────────────────────────────────────

## help: Show available targets
help:
	@echo ""
	@echo "dotfiles Makefile"
	@echo ""
	@echo "  make packages     Install system packages (packages.txt + aur.txt)"
	@echo "  make config       Deploy env/ → \$$HOME"
	@echo "  make tools        Install mise toolchains"
	@echo "  make dry-run      Preview all changes without touching anything"
	@echo "  make test         Full sandbox test suite"
	@echo "  make doctor       Health-check every tool and config"
	@echo ""
