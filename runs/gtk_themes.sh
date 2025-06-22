#!/usr/bin/env bash

engine=(
    unzip
)

# installing engine needed for gtk themes
for PKG1 in "${engine[@]}"; do
    install_package "$PKG1"
done

# Check if the directory exists and delete it if present
if [ -d "GTK-themes-icons" ]; then
    echo "GTK themes and Icons directory exist..deleting..." 2>&1
    rm -rf "GTK-themes-icons" 2>&1
fi

echo "Cloning GTK themes and Icons repository..." 2>&1
if git clone --depth=1 https://github.com/JaKooLit/GTK-themes-icons.git ; then
    cd GTK-themes-icons
    chmod +x auto-extract.sh
    ./auto-extract.sh
    cd ..
    echo "Extracted GTK Themes & Icons to ~/.icons & ~/.themes directories" 2>&1
else
    echo "Download failed for GTK themes and Icons.." 2>&1
fi

printf "\n%.0s" {1..2}