#!/usr/bin/env bash

set -euo pipefail

# Terminate already running bar instances
killall -q polybar || true

# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

# Launch Polybar, using default config location `~/.config/polybar/config.ini` on all monitors
for m in $(polybar --list-monitors | cut -d':' -f1); do
	MONITOR="$m" polybar --reload &
done
unset m
