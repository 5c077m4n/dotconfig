if (( $+commands[kubectl] )); then
	source <(kubectl completion zsh)
fi
if (( $+commands[brew] && $+commands[gopass] )) && [[ ! -f "$(brew --prefix)/share/zsh/site-functions/_gopass" ]]; then
	gopass completion zsh > "$(brew --prefix)/share/zsh/site-functions/_gopass"
fi
