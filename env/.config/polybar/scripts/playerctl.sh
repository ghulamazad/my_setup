#!/bin/bash
# Playerctl — Nerd Font icons
status=$(playerctl status 2>/dev/null | tr '[:upper:]' '[:lower:]')

if [ "$status" = "playing" ]; then
    title=$(playerctl metadata --format '{{title}}' | cut -c 1-26)
    echo "󰎈 $title"
elif [ "$status" = "paused" ]; then
    title=$(playerctl metadata --format '{{title}}' | cut -c 1-20)
    echo "󰏤 $title"
else
    echo ""
fi