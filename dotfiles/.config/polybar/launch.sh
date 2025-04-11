#!/usr/bin/env bash

set -euo pipefail

# Terminate already running bar instances
killall -q polybar || true
killall -q i3blocks || true
killall -q i3status || true

# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

# Launch Polybar, using default config location `~/.config/polybar/config.ini`
polybar --reload &
