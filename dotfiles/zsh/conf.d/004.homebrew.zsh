brew_bin_arm64="/opt/homebrew/bin/brew"
brew_bin_x86="/usr/local/Homebrew/bin/brew"

if [[ -x "$brew_bin_x86" && "$(uname -m)" != arm64 && "$(arch)" != arm64 ]]; then
	brew_bin="$brew_bin_x86"
elif [[ -x "$brew_bin_arm64" ]]; then
	brew_bin="$brew_bin_arm64"
fi

if [[ -n "$brew_bin" ]]; then
	eval "$($brew_bin shellenv)"

	export HOMEBREW_NO_ANALYTICS=1
	export HOMEBREW_BUNDLE_FILE="${XDG_CONFIG_HOME}/homebrew/Brewfile"

	fpath+=("${HOMEBREW_PREFIX}/share/zsh/site-functions")
	path=("${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnubin" $path) # Use GNU tools as default
fi
