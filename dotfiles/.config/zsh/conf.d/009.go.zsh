if (( $+commands[go] )); then
	export GOPATH="${XDG_DATA_HOME}/go"
	export GOBIN="${GOPATH}/bin"

	typeset -TU GOPATH gopath
fi
