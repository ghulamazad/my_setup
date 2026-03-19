#!/bin/bash
# PipeWire volume using pamixer — Nerd Font icons
muted=$(pamixer --get-mute 2>/dev/null)
volume=$(pamixer --get-volume 2>/dev/null)

if [ "$muted" = "true" ]; then
    echo "󰝟 muted"
elif [ "$volume" -le 0 ]; then
    echo "󰕿 ${volume}%"
elif [ "$volume" -le 30 ]; then
    echo "󰖀 ${volume}%"
elif [ "$volume" -le 70 ]; then
    echo "󰕾 ${volume}%"
else
    echo "󰕾 ${volume}%"
fi