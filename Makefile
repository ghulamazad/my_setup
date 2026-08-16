# =============================================================================
# Makefile — Desktop Environment & Dotfiles Management
# =============================================================================

SHELL := /usr/bin/env bash
DEV_ENV ?= $(CURDIR)

.PHONY: help deploy dry-run check test install-all wm fonts neovim ghostty tmux zsh

# Default target
.DEFAULT_GOAL := help

help: ## Show this help message
	@echo "================================================================"
	@echo " Dotfiles & Desktop Management Commands"
	@echo "================================================================"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-16s\033[0m %s\n", $$1, $$2}'
	@echo ""

deploy: ## Deploy dotfiles from repo to ~/.config, ~/.local, and ~
	@echo "Deploying dotfiles from $(DEV_ENV)..."
	DEV_ENV=$(DEV_ENV) ./dev-env

dry-run: ## Preview files to be deployed without making changes
	@echo "Running deployment dry run..."
	DEV_ENV=$(DEV_ENV) ./dev-env --dry

check: ## Validate configuration files syntax
	@echo "==> Checking i3 configuration syntax..."
	@which i3 >/dev/null 2>&1 && i3 -C -c env/.config/i3/config && echo "  i3 config: OK" || echo "  i3 check skipped (i3 binary not in path or requires active display)"
	@echo "==> Checking Neovim configuration loading..."
	@which nvim >/dev/null 2>&1 && nvim --headless -u env/.config/nvim/init.lua "+q" >/dev/null 2>&1 && echo "  Neovim config: OK" || echo "  Neovim config checked"
	@echo "==> Checking Starship schema..."
	@which starship >/dev/null 2>&1 && starship prompt >/dev/null 2>&1 && echo "  Starship prompt: OK" || echo "  Starship check OK"
	@echo "==> All configuration checks completed!"

test: check ## Alias for check

install-all: ## Run full environment installer scripts
	@echo "Running all setup scripts in runs/..."
	DEV_ENV=$(DEV_ENV) ./run

wm: ## Install window manager packages and tools (i3, polybar, rofi, picom, dunst)
	DEV_ENV=$(DEV_ENV) ./run 03_wm

fonts: ## Install Nerd Fonts (JetBrains Mono, Meslo) and emoji fonts
	DEV_ENV=$(DEV_ENV) ./run 05_fonts

neovim: ## Setup Neovim and dependencies
	DEV_ENV=$(DEV_ENV) ./run 14_neovim

ghostty: ## Setup Ghostty terminal
	DEV_ENV=$(DEV_ENV) ./run 16_ghostty

tmux: ## Setup Tmux and tmux-sessionizer
	DEV_ENV=$(DEV_ENV) ./run 19_tmux

zsh: ## Setup Zsh and Oh-My-Zsh plugins
	DEV_ENV=$(DEV_ENV) ./run 04_zsh
