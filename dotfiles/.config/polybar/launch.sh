#!/usr/bin/env bash

set -euo pipefail

# Terminate already running bar instances
killall -q polybar || true

# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

# Launch Polybar, using default config location `~/.config/polybar/config.ini` on all monitors
# Launch bar on each monitor, tray on primary
polybar --list-monitors | while IFS=$'\n' read line; do
	monitor=$(echo "$line" | cut -d':' -f1)
	primary=$(echo "$line" | cut -d' ' -f3)
	MONITOR=$monitor polybar --reload "top${primary:+"-primary"}" &
done
