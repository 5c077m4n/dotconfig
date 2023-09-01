if [[ -d "${KREW_ROOT:-$HOME/.krew}/bin" ]]; then
	path+=("${KREW_ROOT:-$HOME/.krew}/bin")
fi

path+=("${HOME}/.local/bin" "${GOBIN}")
cdpath+=("${HOME}/repos")
