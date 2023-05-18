if [[ -x "$(command -v kubectl)" ]]; then
	source <(kubectl completion zsh)
fi
fpath+=("${ZSH_CUSTOM}/plugins/zsh-completions/src")
