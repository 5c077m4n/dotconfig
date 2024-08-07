brew_bin_arm64="/opt/homebrew/bin/brew"
brew_bin_x86="/usr/local/Homebrew/bin/brew"

if [[ -x "$brew_bin_x86" && "$(uname -m)" != arm64 ]]; then
	brew_bin="$brew_bin_x86"
elif [[ -x "$brew_bin_arm64" ]]; then
	brew_bin="$brew_bin_arm64"
fi

if [[ -n "$brew_bin" ]]; then
	export HOMEBREW_NO_ANALYTICS=1

	eval "$($brew_bin shellenv)"

	export HOMEBREW_PREFIX="$(brew --prefix)"
	export HOMEBREW_BUNDLE_FILE="${HOME}/.config/homebrew/Brewfile"

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

	if (( $+commands[go] )); then
		export GOROOT="$(brew --prefix go)/libexec"
		typeset -TU GOPATH gopath
	fi

	if (( $+commands[emacs] )); then
		export DOOMDIR="${HOME}/.config/doom"

		if [[ ! -d ~/.emacs.d/ ]]; then
			git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.emacs.d
			#~/.emacs.d/bin/doom install
		fi
	fi
fi
