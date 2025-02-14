#!/usr/bin/env sh

if [[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/xmodmap/rc" ]]; then
	xmodmap "${XDG_CONFIG_HOME:-$HOME/.config}/xmodmap/rc"
fi

if [[ $(command -v picom) && ! $(pgrep -x picom) ]]; then
	picom --daemon
fi
