if (( $+commands[go] )); then
	export GOPATH="${XDG_DATA_HOME}/go"
	export GOBIN="${GOPATH}/bin"
	export GOROOT="$(brew --prefix go)/libexec"

	typeset -TU GOPATH gopath
fi
