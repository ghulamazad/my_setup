#!/bin/bash
status=$(playerctl status 2>/dev/null | tr '[:upper:]' '[:lower:]')
if [ "$status" = "playing" ]; then
    title=$(playerctl metadata --format '{{title}}' | cut -c 1-26)
    echo "ﱃ $title     "
elif [ "$status" = "paused" ]; then
    echo "Paused     "
else
    echo "No Player"
fi