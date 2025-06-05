#!/bin/sh
# Adapted for Ubuntu to display number of available package updates

if ! updates_ubuntu=$(apt list --upgradable 2> /dev/null | grep -v "^Listing..." | wc -l); then
    updates_ubuntu=0
fi

if [ $updates_ubuntu -gt 0 ]; then
    echo "📦 $updates_ubuntu"
else
    echo ""
fi