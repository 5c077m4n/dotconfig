() {
	if (( $+commands[brew] )); then
		export HOMEBREW_NO_ANALYTICS=1
		export HOMEBREW_PREFIX="$(brew --prefix)"

		eval "$(brew shellenv)"

		path+=("/opt/homebrew/bin")
		fpath+=("${HOMEBREW_PREFIX}/share/zsh/site-functions")

		# Use GNU tools as default
		local gnu_bin_dir
		for gnu_bin_dir in ${HOMEBREW_PREFIX}/opt/*/libexec/gnubin; do
			[[ -d "$gnu_bin_dir" ]] && path+=("$gnu_bin_dir")
		done

		if [[ -d "${HOMEBREW_PREFIX}/Caskroom/google-cloud-sdk" ]]; then
			# Gcloud init
			export USE_GKE_GCLOUD_AUTH_PLUGIN=True
			export GOOGLE_APPLICATION_CREDENTIALS="${XDG_CONFIG_HOME}/gcloud/application_default_credentials.json"
			source "${HOMEBREW_PREFIX}/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
			source "${HOMEBREW_PREFIX}/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
		fi
	fi
}
