#!/usr/bin/env zsh

arkenfox_user="$(curl https://raw.githubusercontent.com/arkenfox/user.js/master/user.js)"
__dirname="${0:A:h}"
ff_profile_dir="${1:-"."}"

{ echo $arkenfox_user; echo "\n"; cat "${__dirname}/user-overrides.js"; } > "${ff_profile_dir}/user.js"
