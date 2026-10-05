#!/usr/bin/env bash
# install-config.sh – Deploy dotfiles from env/ into $HOME.
#
# Structure: env/ is an exact mirror of $HOME.
#   env/.zshrc              → ~/.zshrc
#   env/.zsh/aliases.zsh    → ~/.zsh/aliases.zsh
#   env/.config/nvim/       → ~/.config/nvim/
#   env/.config/tmux/       → ~/.config/tmux/
#   env/.local/bin/         → ~/.local/bin/   (chmod +x applied)
#   ... and so on.
#
# No routing tables, no per-package logic. env/ IS $HOME.
#
# Behaviour:
#   - Copies (default) or symlinks (--symlink) every file.
#   - Overwrites destination if content differs — env/ is the source of truth.
#   - Skips identical files (sha256 match) — safe to run multiple times.
#   - Never touches protected paths (.config/hypr, .config/omarchy, .ssh, .gnupg).
#   - Files inside .local/bin/ are always made executable.
#
# Usage:
#   ./install-config.sh               – deploy all files
#   ./install-config.sh --symlink     – symlink instead of copy
#   ./install-config.sh --dry-run     – print what would happen, change nothing

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_DIR="${SCRIPT_DIR}/env"   # the home-mirror source tree

# ── Flags ─────────────────────────────────────────────────────────────────────
DRY_RUN=false
SYMLINK=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        --dry-run) DRY_RUN=true ;;
        --symlink) SYMLINK=true ;;
        *) printf 'Unknown flag: %s\nUsage: %s [--dry-run] [--symlink]\n' "$1" "$0" >&2; exit 1 ;;
    esac
    shift
done

# ── Helpers ───────────────────────────────────────────────────────────────────
log()  { printf '\033[1;36m==>\033[0m %s\n' "$*"; }
ok()   { printf '\033[1;32m OK\033[0m %s\n' "$*"; }
skip() { printf '\033[0;37mSKP\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33mWRN\033[0m %s\n' "$*"; }

# ── Protected paths ───────────────────────────────────────────────────────────
# These are owned by Omarchy or the system. Never touched.
PROTECTED=(
    "${HOME}/.config/hypr"
    "${HOME}/.config/omarchy"
    "${HOME}/.ssh"
    "${HOME}/.gnupg"
)

is_protected() {
    local t="$1"
    for p in "${PROTECTED[@]}"; do
        case "$t" in "$p"|"$p"/*) return 0 ;; esac
    done
    return 1
}

# ── Counters ──────────────────────────────────────────────────────────────────
COUNT_INSTALLED=0
COUNT_SKIPPED=0

# ── Install one file ──────────────────────────────────────────────────────────
install_file() {
    local src="$1"
    # Destination: strip env/ prefix, place under $HOME
    local rel="${src#"${ENV_DIR}/"}"
    local dst="${HOME}/${rel}"

    # Safety
    if is_protected "$dst"; then
        warn "Protected – skipping: $dst"
        return 0
    fi

    # Special: git identity template – create only if absent
    if [[ "$dst" == "${HOME}/.config/git/local" ]]; then
        if [[ ! -e "$dst" ]]; then
            if $DRY_RUN; then
                log "[DRY RUN] CREATE template: $dst"
            else
                mkdir -p "$(dirname "$dst")"
                cat > "$dst" <<'EOF'
# ~/.config/git/local – machine identity (never committed to the repo)
[user]
    name  =
    email =
    # signingkey =
EOF
                ok "Created identity template: $dst"
            fi
            (( COUNT_INSTALLED++ )) || true
        else
            skip "Identity file exists (never overwritten): $dst"
            (( COUNT_SKIPPED++ )) || true
        fi
        return 0
    fi

    # Skip if already identical
    if [[ -f "$dst" && -f "$src" ]]; then
        if [[ "$(sha256sum "$src" | awk '{print $1}')" == \
              "$(sha256sum "$dst" | awk '{print $1}')" ]]; then
            skip "Up to date: $dst"
            (( COUNT_SKIPPED++ )) || true
            return 0
        fi
    elif $SYMLINK && [[ -L "$dst" ]]; then
        if [[ "$(readlink -f "$dst" 2>/dev/null)" == "$src" ]]; then
            skip "Symlink correct: $dst"
            (( COUNT_SKIPPED++ )) || true
            return 0
        fi
    fi

    # Install (overwrite – env/ is source of truth)
    if $DRY_RUN; then
        log "[DRY RUN] $src → $dst"
        (( COUNT_INSTALLED++ )) || true
        return 0
    fi

    mkdir -p "$(dirname "$dst")"
    if $SYMLINK; then
        ln -sf "$src" "$dst"
    else
        command cp -a "$src" "$dst"
    fi

    # Files in .local/bin/, .local/scripts/, and ~/.tmux-sessionizer must be executable
    case "$dst" in
        "${HOME}/.local/bin/"*|"${HOME}/.local/scripts/"*|"${HOME}/.tmux-sessionizer") chmod +x "$dst" ;;
    esac

    ok "Installed: $dst"
    (( COUNT_INSTALLED++ )) || true
}

# ── Main ──────────────────────────────────────────────────────────────────────
[[ -d "$ENV_DIR" ]] || { printf 'ERROR: env/ directory not found at %s\n' "$ENV_DIR" >&2; exit 1; }

echo ""
log "install-config.sh  (source: env/ → \$HOME)"
$DRY_RUN && log "DRY RUN – no changes will be made"
$SYMLINK  && log "MODE: symlink" || log "MODE: copy"
echo ""

# Walk every file in env/, sorted for deterministic output
while IFS= read -r -d '' src; do
    install_file "$src"
done < <(find "${ENV_DIR}" -type f -print0 | sort -z)

# ── Post-install checks ────────────────────────────────────────────────────────
if ! $DRY_RUN; then
    echo ""
    log "Post-install checks..."

    if [[ -f "${HOME}/.zshrc" ]] && command -v zsh &>/dev/null; then
        zsh -n "${HOME}/.zshrc" 2>&1 \
            && ok "zsh -n ~/.zshrc: OK" \
            || warn "zsh -n ~/.zshrc: syntax warnings"
    fi

    if [[ -f "${HOME}/.config/git/config" ]] && command -v git &>/dev/null; then
        git config --list --show-origin &>/dev/null \
            && ok "git config: OK" \
            || warn "git config: errors"
    fi

    if command -v nvim &>/dev/null; then
        nvim --headless +qa 2>&1 \
            && ok "nvim --headless: OK" \
            || warn "nvim --headless: errors (run :Lazy sync on first boot)"
    fi
fi

# ── Summary ───────────────────────────────────────────────────────────────────
echo ""
if $DRY_RUN; then
    log "[DRY RUN] Would install=${COUNT_INSTALLED}  skip=${COUNT_SKIPPED}"
else
    log "Done.  installed=${COUNT_INSTALLED}  skipped=${COUNT_SKIPPED}"
fi
