#!/usr/bin/env sh

[[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/xmodmap/rc" ]] && xmodmap "${XDG_CONFIG_HOME:-$HOME/.config}/xmodmap/rc"
