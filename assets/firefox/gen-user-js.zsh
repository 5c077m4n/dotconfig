#!/usr/bin/env zsh

() {
	local arkenfox_user="$(curl https://raw.githubusercontent.com/arkenfox/user.js/master/user.js)"
	local __dirname="$1"
	local ff_profile_dir="${2:-"."}"

	{ echo $arkenfox_user; echo "\n"; cat "${__dirname}/user-overrides.js"; } > "${ff_profile_dir}/user.js"
} "${0:A:h}" "$@"
