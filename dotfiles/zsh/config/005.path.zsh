if [[ -d "${KREW_ROOT:-$HOME/.krew}/bin" ]]; then
	path+=("${KREW_ROOT:-$HOME/.krew}/bin")
fi
if [[ -x "$(command -v kubectl)" ]]; then
	source <(kubectl completion zsh)
fi

path+=("${HOME}/.local/bin" "${GOBIN}")
cdpath+=("${HOME}/repos")
