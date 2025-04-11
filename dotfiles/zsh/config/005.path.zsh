if [[ -d "${KREW_ROOT:-$HOME/.krew}/bin" ]]; then
	path+=("${KREW_ROOT:-$HOME/.krew}/bin")
fi
[[ -f "${HOME}/.cargo/env" ]] && source "${HOME}/.cargo/env"

path+=("${HOME}/.local/bin" "${GOBIN}")
cdpath+=("${HOME}/repos")
