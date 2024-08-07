if [[ -d "${HOMEBREW_PREFIX}/Caskroom/google-cloud-sdk" ]]; then
	# Gcloud init
	export USE_GKE_GCLOUD_AUTH_PLUGIN=True
	export GOOGLE_APPLICATION_CREDENTIALS="${XDG_CONFIG_HOME}/gcloud/application_default_credentials.json"
	source "${HOMEBREW_PREFIX}/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
	source "${HOMEBREW_PREFIX}/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
fi
