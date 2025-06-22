#!/usr/bin/env bash

# Aylur's GTK Shell v 1.9.0 #
# for desktop overview

ags=(
	cmake
    typescript
    nodejs-npm
    meson
    gjs 
    gjs-devel
    gobject-introspection
    gobject-introspection-devel 
    gtk3-devel 
    gtk-layer-shell 
    upower 
    NetworkManager
    pam-devel 
    pulseaudio-libs-devel
    libdbusmenu-gtk3 
    libsoup3
)

# specific tags to download
ags_tag="v1.9.0"

# Check if AGS is installed
if command -v ags &>/dev/null; then
    AGS_VERSION=$(ags -v | awk '{print $NF}') 
    if [[ "$AGS_VERSION" == "1.9.0" ]]; then
        printf "Aylur's GTK Shell v1.9.0 is already installed. Skipping installation."
        printf "\n%.0s" {1..2}
        exit 0
    fi
fi

# Installation of main components
printf "\n%s - Installing Aylur's GTK shell $ags_tag Dependencies \n"

# Installing ags Dependencies
for PKG1 in "${ags[@]}"; do
    install_package "$PKG1"
done

printf "\n%.0s" {1..1}

# ags v1
printf "Install and Compiling Aylur's GTK shell $ags_tag..\n"

# Check if directory exists and remove it
if [ -d "ags" ]; then
    printf "Removing existing ags directory...\n"
    rm -rf "ags"
fi

printf "\n%.0s" {1..1}
printf "Kindly Standby...cloning and compiling Aylur's GTK shell $ags_tag...\n"
printf "\n%.0s" {1..1}
# Clone repository with the specified tag and capture git output into MLOG
if git clone --depth=1 https://github.com/JaKooLit/ags_v1.9.0.git; then
    cd ags_v1.9.0 || exit 1
    npm install
    meson setup build
   if sudo meson install -C build 2>&1; then
    printf "\nAylur's GTK shell $ags_tag installed successfully.\n" 2>&1
  else
    echo -e "\nAylur's GTK shell $ags_tag Installation failed\n " 2>&1
   fi
    cd ..
else
    echo -e "\nFailed to download Aylur's GTK shell $ags_tag Please check your connection\n" 2>&1
    exit 1
fi

printf "\n%.0s" {1..2}