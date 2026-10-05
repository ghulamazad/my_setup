#!/usr/bin/env bash
# bootstrap.sh – Full machine setup in one command.
#
# Runs:  1. install-packages.sh
#         2. install-config.sh
#         3. mise install (pins toolchains)
#
# Idempotent: safe to re-run.  Supports --dry-run, passed through to each step.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── Flags ─────────────────────────────────────────────────────────────────────
DRY_RUN_FLAG=""
for arg in "$@"; do
    case "$arg" in
        --dry-run) DRY_RUN_FLAG="--dry-run" ;;
        *)
            echo "Unknown flag: $arg" >&2
            echo "Usage: $0 [--dry-run]" >&2
            exit 1
            ;;
    esac
done

log()  { printf '\033[1;36m==>\033[0m %s\n' "$*"; }
ok()   { printf '\033[1;32m OK\033[0m %s\n' "$*"; }
err()  { printf '\033[1;31mERR\033[0m %s\n' "$*" >&2; }

# ── Step 1: System packages ───────────────────────────────────────────────────
log "Step 1/3: Installing system packages"
# shellcheck source=install-packages.sh
bash "${SCRIPT_DIR}/install-packages.sh" ${DRY_RUN_FLAG} || {
    err "install-packages.sh failed. Stopping."
    exit 1
}

echo ""

# ── Step 2: Dotfile configs ───────────────────────────────────────────────────
log "Step 2/3: Installing configs"
# shellcheck source=install-config.sh
bash "${SCRIPT_DIR}/install-config.sh" ${DRY_RUN_FLAG} || {
    err "install-config.sh failed. Stopping."
    exit 1
}

echo ""

# ── Step 3: mise toolchains ───────────────────────────────────────────────────
if command -v mise &>/dev/null && [[ -f "${HOME}/.config/mise/config.toml" ]]; then
    log "Step 3/3: Installing mise toolchains"
    if [[ -n "$DRY_RUN_FLAG" ]]; then
        log "[DRY RUN] Would run: mise install"
        log "[DRY RUN] Config: ${HOME}/.config/mise/config.toml"
    else
        mise install || warn "mise install finished with warnings."
        ok "mise toolchains installed."
    fi
else
    log "Step 3/3: Skipping mise install (using system toolchains)"
fi

echo ""
ok "Bootstrap complete."
[[ -n "$DRY_RUN_FLAG" ]] && log "DRY RUN: no changes were made."
