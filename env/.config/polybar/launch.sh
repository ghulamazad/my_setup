#!/usr/bin/env bash

# Ensure polybar is in PATH
if ! command -v polybar >/dev/null; then
    echo "Error: polybar not found. Please install polybar or check PATH."
    exit 1
fi

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do
    echo "Waiting for polybar processes to terminate..."
    sleep 1
done

# Get the list of connected monitors
monitors=$(polybar --list-monitors | cut -d':' -f1)

# Check if monitors were detected
if [ -z "$monitors" ]; then
    echo "Error: No monitors detected. Check 'polybar --list-monitors' output."
    polybar --list-monitors
    exit 1
fi

# Launch Polybar on each monitor
for monitor in $monitors; do
    echo "Launching Polybar on monitor: $monitor"
    # Launch i3 bar (use bspwm bar if you're using bspwm)
    MONITOR=$monitor polybar i3 2>&1 | tee -a /tmp/polybar-$monitor.log & disown
    # If using bspwm, uncomment the following line and comment the i3 line
    # MONITOR=$monitor polybar bspwm 2>&1 | tee -a /tmp/polybar-$monitor.log & disown
done

echo "Polybar launched on all monitors: $monitors"