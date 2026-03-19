#!/usr/bin/env bash
# Polybar launch script — Arch Linux 2026

if ! command -v polybar >/dev/null; then
    echo "Error: polybar not found. Install: sudo pacman -S polybar"
    exit 1
fi

# Kill existing instances
killall -q polybar
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch on all monitors
monitors=$(polybar --list-monitors | cut -d':' -f1)
if [ -z "$monitors" ]; then
    echo "Error: No monitors detected"
    exit 1
fi

for monitor in $monitors; do
    echo "Launching Polybar on: $monitor"
    MONITOR=$monitor polybar i3 2>&1 | tee -a /tmp/polybar-$monitor.log & disown
done

echo "Polybar launched on: $monitors"
