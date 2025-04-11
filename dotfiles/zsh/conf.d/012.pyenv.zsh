if (( $+commands[pyenv] )); then
	export PYENV_ROOT="${XDG_DATA_HOME}/pyenv/$(uname -m)"
	export PATH="${PYENV_ROOT}/bin:${PATH}"

	eval "$(pyenv init -)"
fi
