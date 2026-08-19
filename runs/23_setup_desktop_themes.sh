#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# Fedora - Nordic GTK Theme + Papirus Icons + Bibata Cursor
# User-local installation
# ============================================================

THEME_DIR="$HOME/.local/share/themes"
ICON_DIR="$HOME/.local/share/icons"

NORDIC_REPO="https://github.com/EliverLara/Nordic.git"
PAPIRUS_REPO="https://github.com/PapirusDevelopmentTeam/papirus-icon-theme.git"
BIBATA_REPO="https://github.com/ful1e5/Bibata_Cursor.git"

TMP_DIR="$(mktemp -d)"

cleanup() {
    rm -rf "$TMP_DIR"
}
trap cleanup EXIT

echo "==> Installing dependencies"

sudo dnf install -y git wget curl fontconfig

mkdir -p "$THEME_DIR" "$ICON_DIR"

# ============================================================
# Nordic GTK Theme
# ============================================================

echo
echo "==> Installing Nordic GTK theme"

if [[ -d "$THEME_DIR/Nordic" ]]; then
    echo "Nordic already installed."
else
    git clone --depth=1 "$NORDIC_REPO" "$TMP_DIR/Nordic"

    # The repository itself is the theme directory.
    if [[ ! -f "$TMP_DIR/Nordic/index.theme" ]]; then
        echo "ERROR: Nordic theme files not found."
        exit 1
    fi

    cp -a "$TMP_DIR/Nordic" "$THEME_DIR/Nordic"

    echo "Nordic installed:"
    echo "  $THEME_DIR/Nordic"
fi

# ============================================================
# Papirus Icon Theme
# ============================================================

echo
echo "==> Installing Papirus icon theme"

# Prefer Fedora package.
if rpm -q papirus-icon-theme >/dev/null 2>&1; then
    echo "Papirus already installed."
else
    if sudo dnf install -y papirus-icon-theme; then
        echo "Papirus installed from Fedora."
    else
        echo "Fedora package unavailable. Installing from GitHub..."

        rm -rf "$TMP_DIR/papirus-icon-theme"

        git clone --depth=1 \
            "$PAPIRUS_REPO" \
            "$TMP_DIR/papirus-icon-theme"

        "$TMP_DIR/papirus-icon-theme/install.sh" \
            --destdir "$ICON_DIR"

        echo "Papirus installed locally."
    fi
fi

# ============================================================
# Bibata Modern Classic cursor
# ============================================================

echo
echo "==> Installing Bibata Modern Classic cursor"

BIBATA_VERSION="v2.0.7"
BIBATA_NAME="Bibata-Modern-Classic"
BIBATA_URL="https://github.com/ful1e5/Bibata_Cursor/releases/download/${BIBATA_VERSION}/${BIBATA_NAME}.tar.xz"

if [[ -d "$ICON_DIR/$BIBATA_NAME" ]]; then
    echo "Bibata Modern Classic already installed:"
    echo "  $ICON_DIR/$BIBATA_NAME"
else
    echo "Downloading $BIBATA_NAME..."

    BIBATA_ARCHIVE="$TMP_DIR/${BIBATA_NAME}.tar.xz"

    curl -L \
        --fail \
        --progress-bar \
        "$BIBATA_URL" \
        -o "$BIBATA_ARCHIVE"

    echo "Extracting..."

    tar -xJf "$BIBATA_ARCHIVE" -C "$TMP_DIR"

    if [[ ! -d "$TMP_DIR/$BIBATA_NAME" ]]; then
        echo "ERROR: Bibata archive did not contain $BIBATA_NAME"
        exit 1
    fi

    cp -a "$TMP_DIR/$BIBATA_NAME" "$ICON_DIR/"

    echo "Bibata Modern Classic installed:"
    echo "  $ICON_DIR/$BIBATA_NAME"
fi

# ============================================================
# Verify
# ============================================================

echo
echo "==> Verifying installation"

echo
echo "Nordic:"
if [[ -f "$THEME_DIR/Nordic/index.theme" ]]; then
    echo "  ✓ $THEME_DIR/Nordic"
else
    echo "  ✗ Nordic not found"
fi

echo
echo "Papirus:"
if [[ -d "$ICON_DIR/Papirus" ]] ||
   [[ -d "/usr/share/icons/Papirus" ]]; then
    echo "  ✓ Papirus"
else
    echo "  ✗ Papirus not found"
fi

echo
echo "Papirus-Dark:"
if [[ -d "$ICON_DIR/Papirus-Dark" ]] ||
   [[ -d "/usr/share/icons/Papirus-Dark" ]]; then
    echo "  ✓ Papirus-Dark"
else
    echo "  ✗ Papirus-Dark not found"
fi

echo
echo "Bibata:"
find "$ICON_DIR" /usr/share/icons \
    -maxdepth 1 \
    -type d \
    -iname 'Bibata*' \
    -printf '  ✓ %f\n' \
    2>/dev/null || true

echo
echo "==> Installation complete."