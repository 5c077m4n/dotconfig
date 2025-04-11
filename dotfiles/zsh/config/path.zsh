if [[ -d "${KREW_ROOT:-$HOME/.krew}/bin" ]]; then
	path+=("${KREW_ROOT:-$HOME/.krew}/bin")
fi
# Kubectl
[[ -x "$(command -v kubectl)" ]] && source <(kubectl completion zsh)
