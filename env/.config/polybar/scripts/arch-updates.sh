#!/bin/bash
# Arch Linux updates check — replaces fedora-updates.sh
updates=$(checkupdates 2>/dev/null | wc -l)
aur_updates=$(yay -Qua 2>/dev/null | wc -l)
total=$((updates + aur_updates))
if [ "$total" -gt 0 ]; then
    echo " $total"
else
    echo ""
fi
