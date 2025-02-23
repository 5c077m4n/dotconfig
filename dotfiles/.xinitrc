#!/usr/bin/env sh

if [[ $(command -v picom) && ! $(pgrep -x picom) ]]; then
	picom --daemon
fi
