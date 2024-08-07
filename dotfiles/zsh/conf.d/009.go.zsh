if (( $+commands[go] )); then
	export GOROOT="$(brew --prefix go)/libexec"
	typeset -TU GOPATH gopath
fi
