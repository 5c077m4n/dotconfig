if (( $+commands[brew] )); then
	export HOMEBREW_NO_ANALYTICS=1
	export HOMEBREW_PREFIX="$(brew --prefix)"
	export HOMEBREW_BUNDLE_FILE="${HOME}/repos/dotconfig/assets/macos/Brewfile"

	eval "$(brew shellenv)"

	if [[ -d "${HOMEBREW_PREFIX}/Caskroom/google-cloud-sdk" ]]; then
		# Gcloud init
		export USE_GKE_GCLOUD_AUTH_PLUGIN=True
		export GOOGLE_APPLICATION_CREDENTIALS="${XDG_CONFIG_HOME}/gcloud/application_default_credentials.json"
		source "${HOMEBREW_PREFIX}/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
		source "${HOMEBREW_PREFIX}/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
	fi

	fpath+=("${HOMEBREW_PREFIX}/share/zsh/site-functions")

	# Use GNU tools as default
	path=("${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnubin" $path)
fi
