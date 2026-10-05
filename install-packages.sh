#!/usr/bin/env bash
# install-packages.sh – Install system packages from packages.txt / aur.txt.
#
# NEVER removes or upgrades everything. Only adds what is missing.
# Every sudo call is announced before execution.
#
# Usage:
#   ./install-packages.sh                 – install all packages
#   ./install-packages.sh --dry-run       – print commands, run nothing
#   ./install-packages.sh --official-only – skip AUR
#   ./install-packages.sh --aur-only      – skip official repos

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGES_FILE="${SCRIPT_DIR}/packages.txt"
AUR_FILE="${SCRIPT_DIR}/aur.txt"

# ── Flags ────────────────────────────────────────────────────────────────────
DRY_RUN=false
OFFICIAL_ONLY=false
AUR_ONLY=false

for arg in "$@"; do
    case "$arg" in
        --dry-run)       DRY_RUN=true ;;
        --official-only) OFFICIAL_ONLY=true ;;
        --aur-only)      AUR_ONLY=true ;;
        *)
            echo "Unknown flag: $arg" >&2
            echo "Usage: $0 [--dry-run] [--official-only] [--aur-only]" >&2
            exit 1
            ;;
    esac
done

# ── Helpers ───────────────────────────────────────────────────────────────────
log()  { printf '\033[1;36m==>\033[0m %s\n' "$*"; }
ok()   { printf '\033[1;32m OK\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33mWRN\033[0m %s\n' "$*"; }
err()  { printf '\033[1;31mERR\033[0m %s\n' "$*" >&2; }

# Read a package list file: strip blank lines and # comments, return package names only.
parse_pkg_file() {
    local file="$1"
    [[ -f "$file" ]] || return 0
    grep -v '^\s*#' "$file" | grep -v '^\s*$' | awk '{print $1}'
}

# Check if a package is already installed.
is_installed() {
    pacman -Qi "$1" &>/dev/null
}

# ── Read package lists ────────────────────────────────────────────────────────
mapfile -t OFFICIAL_PKGS < <(parse_pkg_file "$PACKAGES_FILE")
mapfile -t AUR_PKGS      < <(parse_pkg_file "$AUR_FILE")

# ── Categorise ────────────────────────────────────────────────────────────────
OFFICIAL_TO_INSTALL=()
OFFICIAL_ALREADY=()
AUR_TO_INSTALL=()
AUR_ALREADY=()

if ! $AUR_ONLY; then
    for pkg in "${OFFICIAL_PKGS[@]}"; do
        if is_installed "$pkg"; then
            OFFICIAL_ALREADY+=("$pkg")
        else
            OFFICIAL_TO_INSTALL+=("$pkg")
        fi
    done
fi

if ! $OFFICIAL_ONLY; then
    for pkg in "${AUR_PKGS[@]}"; do
        if is_installed "$pkg"; then
            AUR_ALREADY+=("$pkg")
        else
            AUR_TO_INSTALL+=("$pkg")
        fi
    done
fi

# ── Report what will happen ───────────────────────────────────────────────────
echo ""
log "Package installation plan"
echo ""

if [[ ${#OFFICIAL_TO_INSTALL[@]} -gt 0 ]]; then
    echo "  Official packages to install (${#OFFICIAL_TO_INSTALL[@]}):"
    for p in "${OFFICIAL_TO_INSTALL[@]}"; do echo "    + $p"; done
else
    echo "  Official packages: all already installed (${#OFFICIAL_ALREADY[@]})"
fi

if [[ ${#AUR_TO_INSTALL[@]} -gt 0 ]]; then
    echo ""
    echo "  AUR packages to install (${#AUR_TO_INSTALL[@]}):"
    for p in "${AUR_TO_INSTALL[@]}"; do echo "    + $p"; done
elif ! $OFFICIAL_ONLY; then
    echo "  AUR packages: all already installed (${#AUR_ALREADY[@]})"
fi
echo ""

# ── Dry-run mode: print commands and exit ─────────────────────────────────────
if $DRY_RUN; then
    log "[DRY RUN] Commands that would be run:"
    echo ""
    if [[ ${#OFFICIAL_TO_INSTALL[@]} -gt 0 ]]; then
        echo "  sudo pacman -S --needed --noconfirm ${OFFICIAL_TO_INSTALL[*]}"
        echo ""
        log "[DRY RUN] Preview from pacman (--print, no install):"
        pacman -S --needed --print "${OFFICIAL_TO_INSTALL[@]}" 2>/dev/null || true
    fi
    if [[ ${#AUR_TO_INSTALL[@]} -gt 0 ]]; then
        echo ""
        echo "  yay -S --needed --noconfirm ${AUR_TO_INSTALL[*]}"
    fi
    echo ""
    ok "Dry run complete. No changes made."
    exit 0
fi

# ── Nothing to do? ────────────────────────────────────────────────────────────
if [[ ${#OFFICIAL_TO_INSTALL[@]} -eq 0 && ${#AUR_TO_INSTALL[@]} -eq 0 ]]; then
    ok "All packages already installed. Nothing to do."
    exit 0
fi

# ── Install official packages ─────────────────────────────────────────────────
INSTALLED_COUNT=0
FAILED_COUNT=0

if [[ ${#OFFICIAL_TO_INSTALL[@]} -gt 0 ]]; then
    log "SUDO: running pacman -S --needed --noconfirm (${#OFFICIAL_TO_INSTALL[@]} packages)"
    log "Command: sudo pacman -S --needed --noconfirm ${OFFICIAL_TO_INSTALL[*]}"

    if sudo pacman -S --needed --noconfirm "${OFFICIAL_TO_INSTALL[@]}"; then
        INSTALLED_COUNT=$(( INSTALLED_COUNT + ${#OFFICIAL_TO_INSTALL[@]} ))
        ok "Official packages installed."
    else
        err "pacman failed. Stopping."
        FAILED_COUNT=$(( FAILED_COUNT + 1 ))
        echo ""
        echo "Summary: installed=${INSTALLED_COUNT} already_present=${#OFFICIAL_ALREADY[@]} failed=${FAILED_COUNT}"
        exit 1
    fi
fi

# ── Install AUR packages ──────────────────────────────────────────────────────
if [[ ${#AUR_TO_INSTALL[@]} -gt 0 ]]; then
    if ! command -v yay &>/dev/null; then
        echo ""
        warn "yay is not installed but AUR packages are requested:"
        for p in "${AUR_TO_INSTALL[@]}"; do echo "  $p"; done
        echo ""
        read -rp "Install yay now? (requires sudo + base-devel) [y/N] " _reply
        if [[ "$_reply" =~ ^[Yy]$ ]]; then
            log "SUDO: installing yay from AUR manually"
            _tmpdir="$(mktemp -d)"
            git clone https://aur.archlinux.org/yay.git "$_tmpdir/yay"
            (cd "$_tmpdir/yay" && makepkg -si --noconfirm)
            rm -rf "$_tmpdir"
        else
            warn "Skipping AUR packages."
            AUR_TO_INSTALL=()
        fi
    fi

    if [[ ${#AUR_TO_INSTALL[@]} -gt 0 ]]; then
        log "SUDO: running yay -S --needed --noconfirm (${#AUR_TO_INSTALL[@]} packages)"
        log "Command: yay -S --needed --noconfirm ${AUR_TO_INSTALL[*]}"

        if yay -S --needed --noconfirm "${AUR_TO_INSTALL[@]}"; then
            INSTALLED_COUNT=$(( INSTALLED_COUNT + ${#AUR_TO_INSTALL[@]} ))
            ok "AUR packages installed."
        else
            err "yay failed. Stopping."
            FAILED_COUNT=$(( FAILED_COUNT + 1 ))
            echo ""
            echo "Summary: installed=${INSTALLED_COUNT} already_present=$(( ${#OFFICIAL_ALREADY[@]} + ${#AUR_ALREADY[@]} )) failed=${FAILED_COUNT}"
            exit 1
        fi
    fi
fi

# ── Summary ───────────────────────────────────────────────────────────────────
echo ""
ALREADY_PRESENT=$(( ${#OFFICIAL_ALREADY[@]} + ${#AUR_ALREADY[@]} ))
ok "Done. installed=${INSTALLED_COUNT} already_present=${ALREADY_PRESENT} failed=${FAILED_COUNT}"
