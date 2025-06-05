#!/bin/bash
status=$(playerctl status 2>/dev/null | tr '[:upper:]' '[:lower:]')
if [ "$status" = "playing" ]; then
    echo "$(playerctl metadata --format '{{artist}} - {{title}}')"
elif [ "$status" = "paused" ]; then
    echo "Paused"
else
    echo "No Player"
fi